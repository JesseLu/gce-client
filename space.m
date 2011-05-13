function [sp] = space(offset, shape, varargin)
% SP = SPACE(OFFSET, SHAPE, [PITCH])
%
% Description
%     Used to select or determine a three-dimensional set of points for the 
% placement of a field, or the execution of an operation. The points form a 
% rectangular prism.
%
% Inputs
%     OFFSET: 3-element vector.
%         The starting corner of the rectangular prism.
%
%     SHAPE: 3-element vector of positive integers.
%         The number of points along each direction of the space.
%
%     PITCH: 3-element vector of positive numbers (optional).
%         The distance between adjacent points in each direction.
%         Default value: [1.0 1.0 1.0].
%
% Outputs
%     SP: Structure containing space information.

if (isempty(varargin))
    pitch = [1.0 1.0 1.0];
else 
    pitch = varargin{1};
end

sp = struct('offset', offset, 'shape', shape, 'pitch', pitch);

