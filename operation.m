function operation(opname, type, updated_fields, ...
    source, params, sp, step, exec_t, save_t)
% OPERATION(OPNAME, TYPE, UPDATED_FIELDS, ...
%     SOURCE, PARAMS, SP, STEP, EXEC_T, SAVE_T)
% 
% Description
%     Describe a generic operation. This function is generally used by the
% update(), write() and integrate() functions.

global GCE_FILENAME
file = H5F.open(GCE_FILENAME, 'H5F_ACC_RDWR', 'H5P_DEFAULT');


    %
    % Generate a unique name for the operation, and create the dataset.
    %

dset_name = ['operations/', opname];

try
    hdf5write(GCE_FILENAME, dset_name, source, 'WriteMode', 'append');
catch
    sub = 1;
    while (true)
        dset_name = ['operations/', opname, '_sub_', num2str(sub)];
        try
            hdf5write(GCE_FILENAME, dset_name, source, 'WriteMode', 'append');
            break;
        end     
        sub = sub + 1;
    end
end

    %
    % Store the various update parameters as attributes.
    %

% Type of operation.
hdf5_attribute(GCE_FILENAME, 'type', dset_name, type); 

% Time parameters.
hdf5_attribute(GCE_FILENAME, 'step', dset_name, int32(step));
hdf5_attribute(GCE_FILENAME, 'save_tt', dset_name, single(save_t));
hdf5_attribute(GCE_FILENAME, 'exec_tt', dset_name, single(exec_t));

% Space parameters.
hdf5_attribute(GCE_FILENAME, 'shape', dset_name, int32(sp.shape));
hdf5_attribute(GCE_FILENAME, 'offset', dset_name, single(sp.offset));
hdf5_attribute(GCE_FILENAME, 'pitch', dset_name, single(sp.pitch));

% Write parameters.
hdf5_attribute(GCE_FILENAME, 'updated_fields', dset_name, updated_fields);

% Input parameters to the function.
hdf5_attribute(GCE_FILENAME, 'params', dset_name, single(params));
