function integrate(global_dest, source, params, sp, step, varargin)
% INTEGRATE(GLOBAL_DEST, SOURCE, PARAMS, SPACE, STEP, [EXEC_T])
% 
% Description
%     Defines an integrate operation and writes it to the simulation file.
% An integrate operation performs a calculation at every point in a space,
% sums up the result at every point and stores it in a global field.
% 
% Inputs
%     GLOBAL_DEST: Character string.
%         The global field in which the result of the integrate operation 
%         is to be stored.
% 
%     SOURCE: Character string.
%         The Cuda source code that performs the operation. For more information
%         on Cuda see (www.nvidia.com/object/cuda_home.html).
% 
%     PARAMS: 1-dimensional array.
%         Parameter list passed to the integrate operation. These parameters can
%         be accessed via the 'p' variable in the source.
%         If no parameters need to be passed use PARAMS = [].
% 
%     SPACE: Structure containing space information, see space() documentation.
%         Determines every location where the integrate operation will be
%         evaluated.
%
%     STEP: Integer.
%         The step number in which to execute the integration. The step number 
%         of various operations determines their order of execution.
% 
%     EXEC_T: 1-dimensional array (optional).
%         The values of time (defined in gce_start()) in which the integrate 
%         operation will be executed. If EXEC_T = always, then the execution
%         will occur at every iteration.
%         Default value: always.
% 
% Outputs
%     NONE.

    %
    % Automatically generate a name for the operation.
    %

name = ['integrate_', global_dest, '_step_', num2str(step)];


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

operation(name, 'sum', {global_dest}, source, params, sp, step, ...
    exec_t, exec_t);
