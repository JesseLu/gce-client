function SubGrid_analyze(filename, sg_pos, kappa, saturation, delay)
% SUBGRID_ANALYZE(FILENAME, SG_POS, KAPPA, SATURATION, DELAY)
% 
% Description
%     Plot the slice information from the subgrid simulation.

    %
    % Get data from hdf5 file.
    %

slice = squeeze(hdf5read(filename, 'fields/slice'));
subslice = squeeze(hdf5read(filename, 'fields/subslice'));


    %
    % Determine some parameters needed for the visualization.
    %

% Determine colorbar scale.
c = max(abs(slice(:))) / saturation;

% Get the matrix to show where the subgrid is in relation to the main grid.
sub_size = size(subslice)/kappa;
main_size = size(slice);
alpha_data = ones(main_size(1:2));
alpha_data(sg_pos(1):sg_pos(1)+sub_size(1)-1, ...
    sg_pos(2):sg_pos(2)+sub_size(2)-1) = 0.5;


    %
    % Plot the main- and sub-grid simultaneously.
    %

for k = 1 : size(slice, 3)-1
    subplot 121;
    my_plot(slice(:,:,k), c, alpha_data)
    title(num2str(k));

    subplot 122;
    for l = (k-1) * kappa + 1 : k * kappa
        my_plot(subslice(:,:,l), c)
        title(sprintf('%1.2f', l/kappa));

        drawnow;
        pause(delay)
    end
end

function my_plot(s, c, varargin)
if (~isempty(varargin))
    h = imagesc(s.*varargin{1}, c * [-1 1]); % Plot.
else
    imagesc(s, c * [-1 1]); % Plot.
end
axis equal tight; set(gca, 'Ydir', 'normal'); % Make things look pretty.
colormap(interp1([1 0 0; 1 1 1; 0 0 1], 1:0.001:3))
