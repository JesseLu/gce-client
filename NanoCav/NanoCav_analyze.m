function NanoCav_analyze(filename, w, t_cutoff)
% NANOCAV_ANALYZE(FILENAME, W, T_CUTOFF)
% 
% Description
%     Output the results of a simulation defined by Nanocav_make().

    %
    % Two dimensional plot of the last slice field.
    %

figure(1);
slice = hdf5read(filename, 'fields/slice'); % Read slice from hdf5 file.
slice = squeeze(slice(:,:,:,end)); % Obtain the last slice (in time).
imagesc(slice, max(abs(slice(:))) * [-1 1]); % Plot.
axis equal tight; set(gca, 'Ydir', 'normal'); % Make things look pretty.
drawnow;


    %
    % Plot the point output in time and frequency.
    %

figure(2);
dt = 0.99 / sqrt(3); % This needs to be the actual time step used in simulation.
point_output = squeeze(hdf5read(filename, 'fields/point')); % Get the data.
plot_point(point_output, w, t_cutoff, dt); % Plot. 
drawnow;


    %
    % Fit energy and power and compute quality factors.
    %

NanoCav_compute_Q(filename, t_cutoff, [3 4])

