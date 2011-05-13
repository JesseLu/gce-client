function write(source_field, dest_field, sp, step, exec_t)
% UPDATE(SOURCE_FIELD, DEST_FIELD, SPACE, STEP, EXEC_T)
% 
% Description
%     Write/save the values of a field to the hdf5 file.
% 
% Inputs
%     SOURCE_FIELD: Character string.
%         Name of the field to save values from.
% 
%     DEST_FIELD: Character string.
%         Name of the field to save the values to. The values will be added to
%         the hdf5 file under this field's name.
% 
%     SPACE: Structure containing space information, see space() documentation.
%         Determines every location where the write operation will be
%         evaluated.
%
%     STEP: Integer.
%         The step number in which to execute the write. The step number of 
%         various operations determines their order of execution.
% 
%     EXEC_T: 1-dimensional array .
%         The values of time (defined in gce_start()) in which the write
%         operation will be executed. If EXEC_T = always, then the execution
%         will occur at every iteration.
% 
% Outputs
%     NONE.

% Generate the name for the write operation.
name = ['write_', source_field, '_to_', dest_field, '_step_', num2str(step)];

% Generate the source code.
source = [dest_field, '(i,j,k) = ', source_field, '(i,j,k);'];

% Create the operation.
operation(name, 'update', {dest_field}, source, [], sp, step, exec_t, exec_t);
