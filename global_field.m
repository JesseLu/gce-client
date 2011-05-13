function global_field(name, varargin)
% GLOBAL_FIELD(NAME, [DATA])
% 
% Description
%     Defines a global field and writes it to the simulation file. A global
% field is a single number, generally the result of an integrate operation.
% 
% Inputs
%     NAME: Character string.
%         The name of the field.
% 
%     DATA: Single number.
%         If Data = [], then Data = 0.0.
%         Default value: [].
% 
% Outputs
%     NONE.

global GCE_FILENAME
file = H5F.open(GCE_FILENAME, 'H5F_ACC_RDWR', 'H5P_DEFAULT');


    %
    % Create the dataset used to store the field information.
    %

dset_name = ['fields/', name];

% Define the dataset by creating a dataspace.
H5S_UNLIMITED = H5ML.get_constant_value('H5S_UNLIMITED');
maxdims = [H5S_UNLIMITED];
curdims = [1];
space = H5S.create_simple(1, curdims, maxdims);

% Set the chunk size of the dataset.
dcpl = H5P.create('H5P_DATASET_CREATE');
H5P.set_chunk (dcpl, curdims);
% Create the dataset. The datatype is 32-bit float (single precision).
dset = H5D.create(file, dset_name, 'H5T_IEEE_F32BE', space, dcpl);

% Write the data to the dataset. If data is empty, write nothing.
if (isempty(varargin))
    data = [];
else
    data = varargin{1};
end

if (~isempty(data))
    H5D.write(dset,'H5ML_DEFAULT','H5S_ALL','H5S_ALL','H5P_DEFAULT', ...
        reshape(single(data), curdims));
end

% Close everything.
H5P.close(dcpl);
H5D.close(dset);
H5S.close(space);
H5F.close(file);
