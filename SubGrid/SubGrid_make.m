function SubGrid_make(filename, epsilon, sub_kappa, sub_pos, sub_epsilon, ...
    d_pml, num_iters, current_sources)
% SUBGRID_MAKE(FILENAME, EPSILON, SUB_KAPPA, SUB_POS, SUB_EPSILON, ...
%     D_PML, NUM_ITERS, CURRENT_SOURCES)
% 
% Description
%     Creates an electromagnetic grid with a subgridded, high-resolution area.


    % 
    % Initialize the gce simulation definition.
    %

% Need additional timesteps for the subgrid.
gce_start(filename, 0 : 1/sub_kappa : num_iters-1);
mg_t = 0 : num_iters-1; % Main grid time steps


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
% This may need to be decreased to avoid instabilities at the main- and 
% sub-grid boundary.
dt = 0.75 / sqrt(3); 

% Generate the source code for the update equations for both primary fields.
E_update_code = my_import('E_update.cu', 'd_pml', d_pml, ...
    'xx', shape(1), 'yy', shape(2), 'zz', shape(3));
H_update_code = my_import('H_update.cu', 'd_pml', d_pml, ...
    'xx', shape(1), 'yy', shape(2), 'zz', shape(3));

% Describe the update operations for both primary fields.
update({'Ex', 'Ey', 'Ez'}, E_update_code, dt, sp, 2, mg_t);
update({'Hx', 'Hy', 'Hz'}, H_update_code, dt, sp, 4, mg_t);


    %
    % Insert the subgrid.
    %

sg_space = space(sub_pos, size(sub_epsilon{1})/sub_kappa);
sg_E = SubGrid_insert('sub', sg_space, sub_kappa, mg_t, dt, [0.8 0.95]);


    %
    % Describe the current source update operation.
    %

for s = current_sources
    source = s{1};

    % Calculate parameters for current source.
    fwhm = source(2);
    delay = 7;
    alpha = fwhm^2 / 8 * log(2);
    delay = (delay/sqrt(2*alpha));

    % Form the update operation.
    update({'Ez'}, ...
        'Ez(i,j,k) += sinf(p(0) * (p(1) * t - p(3))) * expf(-p(2) * powf(p(1) * t - p(3), 2.0));', ...
        [source(1), dt, alpha, delay], ...
        space(source(3:5), [1 1 1]), 3, mg_t);
end


    %
    % Describe the slice save field and operation.
    %

% Define the location and shape of the slice.
slice_sp = space([0 0 round(shape(3)/2)], [shape(1) shape(2) 1]);

field('slice', slice_sp); % Create the slice field.

% Describe the slice save operation.
write('Ez', 'slice', slice_sp, 4, mg_t);


    %
    % Describe the slice subsave field and operation.
    %

% subslice_sp.offset = space([sg_space.offset(1), sg_space.offset(2), slice_sp.offset(3)], [sg_space.shape(1), sg_space.shape(2), 1], sg_space.pitch);
subslice_sp = sg_E;
subslice_sp.offset(3) = slice_sp.offset(3);
subslice_sp.shape(3) = 1;

field('subslice', subslice_sp); % Create the slice field.

% Describe the slice save operation.
write('subEz', 'subslice', subslice_sp, 4, always);


    %
    % Add the PML absorbing boundary layers.
    %

avg_epsilon = mean([epsilon{1}(:); epsilon{2}(:); epsilon{3}(:)]);
insert_cpml(shape, d_pml, avg_epsilon, dt, mg_t);


    %
    % End the gce description.
    %

gce_end
