function hdf5_attribute (filename, attr_name, dset_name, data)
% HDF5_ATTRIBUTE (FILENAME, ATTR_NAME, DSET_NAME, DATA)
% 
% Description
%     Writes an attribute to an hdf5 file. GCE internal use only.

details = struct('Name', attr_name, 'AttachedTo', dset_name, ...
    'AttachType', 'dataset');
hdf5write(filename, details, data, 'WriteMode', 'append');
