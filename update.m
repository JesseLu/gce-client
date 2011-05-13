function update(updated_fields, source, params, sp, step, varargin)
% UPDATE(UPDATED_FIELDS, SOURCE, PARAMS, SPACE, STEP, [EXEC_T])
% 
% Description
%     Defines an update operation and writes it to the simulation file.
% 
% Inputs
%     UPDATED_FIELDS: Cell-array of character strings.
%         Lists the fields which are modified by the update operation. This is
%         used to automate parallelization.
% 
%     SOURCE: Character string.
%         The Cuda source code that performs the operation. For more information
%         on Cuda see (www.nvidia.com/object/cuda_home.html).
% 
%     PARAMS: 1-dimensional array.
%         Parameter list passed to the update operation. These parameters can
%         be accessed via the 'p' variable in the source.
%         If no parameters need to be passed use PARAMS = [].
% 
%     SPACE: Structure containing space information, see space() documentation.
%         Determines every location where the update operation will be
%         evaluated.
%
%     STEP: Integer.
%         The step number in which to execute the update. The step number of 
%         various operations determines their order of execution.
% 
%     EXEC_T: 1-dimensional array (optional).
%         The values of time (defined in gce_start()) in which the update  
%         operation will be executed. If EXEC_T = always, then the execution
%         will occur at every iteration.
%         Default value: always.
% 
% Outputs
%     NONE.

    %
    % Automatically generate a name for the operation.
    %

name = 'update_';
for k = 1 : length(updated_fields)
    name = [name, updated_fields{k}, '_'];
end
name = [name, 'step_', num2str(step)];


    %
    % Determine the execution times.
    %

if (isempty(varargin))
    exec_t = always;
else
    exec_t = varargin{1};
end


    % 
    % Write operation to file.
    %

operation(name, 'update', updated_fields, source, params, sp, step, ...
    exec_t, never);
