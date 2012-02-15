function simple_wg_example(filename, grid_shape, omega, fwhm, num_iters, theta)
% SHIFTED_L3_EXAMPLE(FILENAME, GRID_SHAPE, OMEGA, FWHM, NUM_ITERS, THETA)
%
% % Description
%     Use the NanoCav gce (Grid Compute Engine) app to find modes of a
%     simple nanophotonic waveguide.
%
%     Try: shifted_wg_example('wg_example.h5', [40 100 100], 0.05, 0.02, 20000, pi/4);

% Height and width of waveguide, in grid points.
h = 20; 
w = 40;

eps_Si = 12.25; % Relative permittivity of silicon.
eps_air = 1.0;

    %
    % Simulation parameters.
    %

pml_thickness = 10; % Thickness of the pml, in cells.


    %
    % Build the shifted L3 cavity, i.e. determine epsilon.
    %


% Create the slab. Be careful of offsets in the Yee grid, and smoothing.
offsets = [0 0 0.5];
center = round(grid_shape(3)/2);
edge_len = 1;

e = draw_structure(grid_shape(1:2), {[1 0 0 1e9 w eps_Si]}, edge_len);
for k = 1 : 3
    z = offsets(k) + [1 : grid_shape(3)];

    % Make the weighting function.
    w = (h/2 - abs(z - center)) / edge_len;
    w = 1 * (w > 0.5) + (w+0.5) .* ((w>-0.5) & (w <= 0.5));
    % plot(w, '.-'); pause;

    % Apply the weighting function.
    epsilon{k} = zeros(grid_shape);
    for m = 1 : grid_shape(3)
        epsilon{k}(:,:,m) = (1-w(m)) * eps_air + w(m) * e{k};
    end
end

ex = epsilon{1};
ey = epsilon{2};
ez = epsilon{3};



    % 
    % Define the simulation using the NanoCav app, built on gce (Grid Compute 
    % Engine).
    %

NanoWg_make(filename, {ex, ey, ez}, pml_thickness, num_iters, ...
    [omega, fwhm], theta);
