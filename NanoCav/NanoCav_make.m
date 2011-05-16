function NanoCav_make(filename, epsilon, d_pml, num_iters, ...
    source, in_plane_height)
% NANOCAV_MAKE(FILENAME, EPSILON, D_PML, NUM_ITERS, SOURCE, IN_PLANE_HEIGHT)
%
% Description
%     Uses gce (Grid Compute Engine) to set up a nanophotonic resonator 
%     simulation.
% 
% Reference: Taflove and Hagness, Computational Electrodynamics (2005).


    % 
    % Initialize the gce simulation definition.
    %

gce_start(filename, 0 : num_iters-1);


    %
    % Determine the size and location of the primary grid.
    %

shape = size(epsilon{1});
sp = space([0 0 0], shape);


    %
    % Primary update equations and fields.
    %

% Describe E- and H-fields.
field('Ex', sp);
field('Ey', sp);
field('Ez', sp);
field('Hx', sp);
field('Hy', sp);
field('Hz', sp);

% Describe epsilon (structure) fields.
field('ex', sp, epsilon{1});
field('ey', sp, epsilon{2});
field('ez', sp, epsilon{3});

% Time discretization for numerical stability. 
% See Courant factor (page 43 of the reference).
dt = 0.99 / sqrt(3); 

% Generate the source code for the update equations for both primary fields.
E_update_code = my_import('E_update.cu', 'd_pml', d_pml, ...
    'xx', shape(1), 'yy', shape(2), 'zz', shape(3));
H_update_code = my_import('H_update.cu', 'd_pml', d_pml, ...
    'xx', shape(1), 'yy', shape(2), 'zz', shape(3));

% Describe the update operations for both primary fields.
update({'Ex', 'Ey', 'Ez'}, E_update_code, dt, sp, 2);
update({'Hx', 'Hy', 'Hz'}, H_update_code, dt, sp, 4);


    %
    % Describe the current source update operation.
    %

% Calculate parameters for current source.
fwhm = source(2);
delay = 7;
alpha = fwhm^2 / 8 * log(2);
delay = (delay/sqrt(2*alpha));

% Form the update operation.
update({'Ey'}, ...
    'Ey(i,j,k) += sinf(p(0) * (p(1) * t - p(3))) * expf(-p(2) * powf(p(1) * t - p(3), 2.0));', ...
    [source(1), dt, alpha, delay], ...
    space(round(shape/2), [1 1 1]), 3);


    %
    % Describe the slice save field and operation.
    %

% Define the location and shape of the slice.
slice_sp = space([0 0 round(shape(3)/2)], [shape(1) shape(2) 1]);

field('slice', slice_sp); % Create the slice field.

% Describe the slice save operation.
write('Ey', 'slice', slice_sp, 4, num_iters-201 : 10 : num_iters-1); 


    %
    % Describe the point save field and operation.
    %

% Define the location and shape of the point. 
point_sp = space(round(shape/2) + 2, [1 1 1]);

field('point', point_sp); % Create the point field.

% Describe the point save operation.
write('Ey', 'point', point_sp, 4, always);


    %
    % Add the PML absorbing boundary layers.
    %

avg_epsilon = mean([epsilon{1}(:); epsilon{2}(:); epsilon{3}(:)]);
insert_cpml(shape, d_pml, avg_epsilon, dt, always);


    %
    % Add fields and operations necessary for energy calculation.
    %

global_field('energy');

energy_sp = space((d_pml + 1) * [1 1 1], shape - 2 * (d_pml + 1));
source_code = 'ex(i,j,k) * powf(Ex(i,j,k), 2) + ey(i,j,k) * powf(Ey(i,j,k), 2) + ez(i,j,k) * powf(Ez(i,j,k), 2) + powf(Hx(i,j,k), 2) + powf(Hy(i,j,k), 2) + powf(Hz(i,j,k), 2);';
integrate('energy', source_code, [], energy_sp, 1);

    
    %
    % Add fields and operations for power calculations.
    %

h = in_plane_height; % Number of cells in central band, for in-plane losses.

% Three boxes for leakage out-of-plane downwards and upwards as well as 
% in-plane.
box_names = {'bot', 'mid', 'top'}; 

% Describe the locations of all three boxes.
z_start =  [d_pml+1,                  (shape(3)-h)/2, (shape(3)+h)/2];
z_height = [(shape(3)-h)/2-(d_pml+1), h,              (shape(3)-h)/2-(d_pml+1)];

% Form fields and operations for all three boxes.
for k = 1 : length(box_names)
    insert_poynting_box (['box_', box_names{k}], ...
        [(d_pml+1)*[1 1], z_start(k)], ...
        [shape(1:2)-2*(d_pml+1), z_height(k)], 1, always);
end


    %
    % End the gce description.
    %

gce_end
