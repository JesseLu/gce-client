function field(name, sp, varargin)
% FIELD(NAME, SPACE, [DATA])
% 
% Description
%     Defines a three-dimensional field. And writes it to the simulation file.
% 
% Inputs
%     NAME: Character string.
%         The name of the field.
% 
%     SPACE: Structure containing space information, see space() documentation.
%         Location, size and pitch of the field.
% 
%     DATA: Three dimensional array.
%         The dimensions of DATA must be SPACE.SHAPE. If Data = [], then the 
%         values of the field will be filled with zeros.
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

% Define the size of the dataset by creating a dataspace.
% The actual dataset will be 4-D, which allows us to save multiple instances of
% the grid, needed when we want to save output values.
H5S_UNLIMITED = H5ML.get_constant_value('H5S_UNLIMITED');
maxdims = [H5S_UNLIMITED sp.shape];
curdims = [1 sp.shape];
space = H5S.create_simple(4, curdims, maxdims);

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
    % Convert from column-major (Matlab) to row-major form (hdf5).
    data_rowmajor = permute(data, [3 2 1]); 
    H5D.write(dset,'H5ML_DEFAULT','H5S_ALL','H5S_ALL','H5P_DEFAULT', ...
        reshape(single(data_rowmajor), curdims));
end

% Close everything.
H5P.close(dcpl);
H5D.close(dset);
H5S.close(space);
H5F.close(file);


    %
    % Write the relevant space data: offset and pitch.
    %

write_attribute(GCE_FILENAME, 'offset', dset_name, single(sp.offset));
write_attribute(GCE_FILENAME, 'pitch', dset_name, single(sp.pitch));
