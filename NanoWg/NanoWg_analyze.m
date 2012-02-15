function NanoWg_analyze(filename, w, t_cutoff, movie_option)
% NANOWG_ANALYZE(FILENAME, W, T_CUTOFF, MOVIE_OPTION)
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
%     MOVIE_OPTION: Boolean.
%         If true, plots a movie. 

    %
    % Plot the point output in time and frequency.
    %

figure(1);
dt = 0.99 / sqrt(3); % This needs to be the actual time step used in simulation.
point_output = squeeze(hdf5read(filename, 'fields/point')); % Get the data.
plot_point(point_output, w, t_cutoff, dt); % Plot. 
drawnow;


    %
    % Play a movie.
    %

mag = 1;
if movie_option
    figure(2); colormap('jet');
    E_slice = hdf5read(filename, 'fields/E_slice'); % Read slice from hdf5 file.
    D_slice = hdf5read(filename, 'fields/D_slice'); % Read slice from hdf5 file.
    for k = 1 : size(E_slice,4)
        subplot 121;
        s = squeeze(E_slice(:,:,:,k)); % Obtain a slice in time.
        imagesc(s, mag * max(abs(E_slice(:))+eps) * [-1 1]); % Plot.
        axis equal tight; set(gca, 'Ydir', 'normal'); % Make things look pretty.
        title('Real component of u(r)');
        drawnow;
        subplot 122;
        s = squeeze(D_slice(:,:,:,k)); % Obtain a slice in time.
        imagesc(s, mag * max(abs(D_slice(:))+eps) * [-1 1]); % Plot.
        axis equal tight; set(gca, 'Ydir', 'normal'); % Make things look pretty.
        title('Imaginary component of u(r)');
        drawnow;
        pause(0.1);
    end
end

