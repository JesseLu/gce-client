% THERMAL_EXAMPLE
%
% This is a short demo/tutorial which serves to demonstrate the basics of gce.
% 
% In this tutorial, we will build a gce simulation to solve the 3D heat 
% equation.
% 
% The file "gce_thermal_example.h5" should be created when this matlab script 
% is executed. Follow the instructions at brainiac5.stanford.edu to execute the simulation.
% 
% Finally, use the THERMAL_PLOT function to view simulation results.

help thermal_example % Print out the help message

path(path, '..'); % Tell Matlab to look in the gce-client directory.


    %
    % Initialize the gce simulation.
    %

% Initialize gce simulation: The gce simulation will be saved to a new file 
% named 'gce_thermal_example.h5' (it will overwrite existing files), 
% and this simulation will run for 10,001 time steps.
gce_start('gce_thermal_example.h5', 0 : 1e4);

% Initial conditions: Create a matlab variable (3D array) with the initial
% temperatures of the system.
u0 = zeros([100 100 100]); % Zero everywhere.
u0(20:80, 40:60, 40:60) = 1; % Except in this cube.


% Set-up field
sp = space([0 0 0], [100 100 100]);
field('u', sp, u0);
field('du', sp);
field('alpha', sp, ones([100 100 100]));

% Define update operations.
update({'du'}, 'du(i,j,k) = alpha(i,j,k) * ((u(i+1,j,k) - 2*u(i,j,k) + u(i-1,j,k)) + (u(i,j+1,k) - 2*u(i,j,k) + u(i,j-1,k)) + (u(i,j,k+1) - 2*u(i,j,k) + u(i,j,k-1)));', ...
    [], sp, 1);
update({'u'}, 'u(i,j,k) += p(0) * du(i,j,k);', 0.1, sp, 2);
% update({'u'}, 'u(i,j,k) += 10.0 * sinf(p(0) * t);', 0.008, ...
%    space([50 50 50], [1 1 1]), 4);

% Visualize central slice.
slice_sp = space([0 0 50], [100 100 1]);
field('slice', slice_sp);
write('u', 'slice', slice_sp, 3, 0 : 1e2 : 1e4);

% Calculate total energy.
global_field('energy');
integrate('energy', 'powf(u(i,j,k), 2.0);', [], sp, 3);

% Done!
gce_end
