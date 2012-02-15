function NanoCav_make(filename, epsilon, d_pml, num_iters, source, theta)
% NANOWG_MAKE(FILENAME, EPSILON, D_PML, NUM_ITERS, SOURCE, THETA)
%
% Description
%     Uses gce (Grid Compute Engine) to set up a nanophotonic resonator 
%     simulation.
% 
% Inputs
%     FILENAME: Character string.
%         Name of the hdf5 file to be created. FILENAME should end in .h5
% 
%     EPSILON: 3-element cell array.
%         Cell array holding the values of epsilon_x, epsilon_y, and epsilon_z.
% 
%     D_PML: Positive integer.
%         Thickness (in number of grid points) of the PML absorbing boundaries.
% 
%     NUM_ITERS: Positive integer.
%         Number of iterations with which to run the simulation.
% 
%     SOURCE: 2-element vector.
%         SOURCE consists of [OMEGA, FWHM], where OMEGA is the angular frequency
%         and FWHM is the ful-width-half-maximum of the current source placed at
%         the center of the grid. This current source has an Ey-orientation.
%
%     THETA: Scalar.
%         The phase relationship for the Bloch boundary condition, in radians.
%         In other words, set THETA = exp(-i * k * xx), where k is the
%         wave-vector of interest, and xx is the number of grid points in the
%         x-direction.
% 
% References: 
%     Taflove and Hagness, Computational Electrodynamics (2005), also see  
%     http://bit.ly/lUh4gF for a description of the primitive Yee cell used.
%     Unshortened link: https://github.com/JesseLu/misc/blob/master/scribblings/primitive%20yee%20cell.pdf?raw=true
%     


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

% Imaginary component of E- and H-fields.
field('Dx', sp);
field('Dy', sp);
field('Dz', sp);
field('Bx', sp);
field('By', sp);
field('Bz', sp);

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
E_jump_beg = my_import('E_update_jump.cu', 'jump', shape(1));
E_jump_end = my_import('E_update_jump.cu', 'jump', -shape(1));

% Describe the update operations for both primary fields.
update({'Ex', 'Ey', 'Ez', 'Dx', 'Dy', 'Dz'}, E_update_code, dt, sp, 2);
update({'Hx', 'Hy', 'Hz', 'Bx', 'By', 'Bz'}, H_update_code, dt, ...
    space([-1 0 0], shape + [1 0 0]), 4);
update({'Ex', 'Ey', 'Ez', 'Dx', 'Dy', 'Dz'}, E_jump_beg, ...
    [cos(theta) sin(theta)], space([-1 0 0], [1 shape(2) shape(3)]), 3);
update({'Ex', 'Ey', 'Ez', 'Dx', 'Dy', 'Dz'}, E_jump_end, ...
    [cos(-theta) sin(-theta)], space([shape(1) 0 0], [1 shape(2) shape(3)]), 3);



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
    space(round(shape/2 + [3 3 3]), [1 1 1]), 3);

% % Form the update operation (for D-field).
% update({'Dy'}, ...
%     'Dy(i,j,k) += sinf(p(0) * (p(1) * t - p(3))) * expf(-p(2) * powf(p(1) * t - p(3), 2.0));', ...
%     [source(1), dt, alpha, delay], ...
%     space(round(shape/2), [1 1 1]), 3);


    %
    % Describe the slice save field and operation.
    %

% Define the location and shape of the slice.
slice_sp = space([0 0 round(shape(3)/2)], [shape(1) shape(2) 1]);

field('E_slice', slice_sp); % Create the slice field.
field('D_slice', slice_sp); % Create the slice field.

% Describe the slice save operation.
write('Ey', 'E_slice', slice_sp, 4, num_iters-501 : 10 : num_iters-1); 
write('Dy', 'D_slice', slice_sp, 4, num_iters-501 : 10 : num_iters-1); 


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
insert_cpml('EH', shape, d_pml, avg_epsilon, dt, always);
insert_cpml('DB', shape, d_pml, avg_epsilon, dt, always);
    

    %
    % End the gce description.
    %

gce_end
