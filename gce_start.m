function gce_start(filename, t, varargin)
% GCE_START(FILENAME, T, [STENCIL])
%
% Description
%     Initializes a gce simulation. This must be run at the beginning of 
% any gce simulation.
%
% Inputs
%     FILENAME: Character string.
%         The name of the hdf5 file used to store the simulation information.
%         Overwrites any existing file of the same name.
%     
%     T: 1-dimensional array.
%         Stores the value of t (time) for every iteration of the simulation.
% 
%     STENCIL: 3-element vector (optional).
%         Used for auto-parallelization. Describes the maximum dependency
%         of all operations on their nearest neighbors in three dimensions.
%         If not given, then a stencil of [1.0 1.0 1.0] will be used, which
%         means that all operations will depend at most on the values of 
%         neighboring cells a distance of 1.0 in each direction away. 
%         Operations may never depend on diagonal-adjacent cell values.
%
% Outputs
%     NONE.

    %
    % Set up the filename as a global variable.
    %

global GCE_FILENAME
GCE_FILENAME = filename;


    %
    % Initialize the hdf5 file.
    %

% Create the hdf5 file for writing.
file = H5F.create(GCE_FILENAME, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

% Create the groups.
groupnames = {'info', 'fields', 'operations'};
for k = 1 : length(groupnames)
    H5G.create(file, groupnames{k}, 'H5P_DEFAULT', 'H5P_DEFAULT', 'H5P_DEFAULT');
end


    %
    % Write the time information.
    %

hdf5write(filename, ['info/t'], single(t), 'WriteMode', 'append');


    %
    % Write the stencil size.
    %

if (isempty(varargin))
    stencil = [1.0 1.0 1.0]; % Default stencil value.
else
    stencil = varargin{1};
end

hdf5write(filename, ['info/stencil'], single(stencil), 'WriteMode', 'append');
