function NanoCav_analyze(filename, w, t_cutoff, qcalc_option)
% NANOCAV_ANALYZE(FILENAME, W, T_CUTOFF, QCALC_OPTION)
% 
% Description
%     Output the results of a simulation defined by Nanocav_make(). 
%
% Inputs
%     FILENAME: Character string.
%         Name of file containing the simulated gce model.
% 
%     W: Number.
%         Frequency of interest (estimated frequency of the mode).
% 
%     T_CUTOFF: Positive number.
%         Ignores the field values before T_CUTOFF.
%
%     QCALC_OPTION: Boolean.
%         If true, calculates the Q-factors of the mode. 
%         If false, do not perform Q-calculation.

    %
    % Two dimensional plot of the last slice field.
    %

figure(1); subplot 111;
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

if qcalc_option
    NanoCav_compute_Q(filename, t_cutoff, [3 4])
end

