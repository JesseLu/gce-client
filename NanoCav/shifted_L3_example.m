function shifted_L3_example(filename, grid_shape, a, omega, fwhm, num_iters)
% SHIFTED_L3_EXAMPLE(FILENAME, GRID_SHAPE, A, OMEGA, FWHM, NUM_ITERS)
%
% % Description
%     Use the NanoCav gce (Grid Compute Engine) app to simulate the photonic
%     crystal cavity found in: 
%         Akahane et al, High-Q photonic nanocavity in a two-dimensional 
%         photonic crystal, Nature 2003.
%   
%     Used as a validation of both gce and NanoCav in the spring of 2011.

    %
    % Structure parameters.
    %

d = 0.6; % Thickness of slab, in units of a.
shift = 0.15; % Shift of outer holes, in units of a.
r = 0.29; % Hole radii, in units of a.


    %
    % Simulation parameters.
    %

pml_thickness = 10; % Thickness of the pml, in cells.

% Height of the box calculating in-plane leakage, in cells.
% Since d = 0.6a, in_plane_height is set to 0.6a + 2 * 3 cells. This extends
% the in-plane loss calculation to 3 cells above and below the slab.
in_plane_height = round(d * a) + 2 * 3;


    %
    % Build the shifted L3 cavity, i.e. determine epsilon.
    %

[ex, ey, ez] = L3_structure(grid_shape, pml_thickness, a, d, shift, r);


    % 
    % Define the simulation using the NanoCav app, built on gce (Grid Compute 
    % Engine).
    %

NanoCav_make(filename, {ex, ey, ez}, pml_thickness, num_iters, ...
    [omega, fwhm], in_plane_height);
