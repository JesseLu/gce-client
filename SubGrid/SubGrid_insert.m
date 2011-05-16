function [sg_E] = SubGrid_insert(prefix, mg, kappa, mg_t, dt, avg_coeff)
% SG_E = SUBGRID_INSERT(PREFIX, MG, KAPPA, MG_T, DT, AVG_COEFF)
% 
% Description
%     Inserts a high-resolution subgrid into an electromagnetic simulation.
%     Reference: Chevalier et al, FDTD Local Grid with Material Transverse,
%     IEEE Trans. on Antennas and Propagation (1997).

% An offset introduced because of the way the rest of the functions are 
% defined.
mg.offset = mg.offset-1;

    
    % 
    % Construct the fields needed for the subgrid.
    %

fieldname = {'Ex', 'Ey', 'Ez', 'Hx', 'Hy', 'Hz'};
epsilon_names = {'ex', 'ey', 'ez'};

% Describes the h-field locations of the subgrid.
sg = space(mg.offset + 0.5 * (1 - (1/kappa)) * mg.pitch, ...
    kappa * mg.shape + 1, ... % Need (+1) because of subgrid definition.
    mg.pitch / kappa);

% Create the subgrid h-fields.
for k = 4 : 6
    field([prefix, fieldname{k}], sg);
end

% The subgrid E- and e-fields are offset relative to the h-fields.
% It is in this space that the user must insert the subgrid epsilon values,
% and eventually their own subE-field update equation.
sg_E = sg;
sg_E.offset = sg_E.offset + sg_E.pitch;
sg_E.shape = sg_E.shape - 1;

% Create the subgrid e-fields and epsilon fields.
for k = 1 : 3
    field([prefix, epsilon_names{k}], sg_E, ones(sg_E.shape));
    field([prefix, fieldname{k}], sg_E);
end

    
    %
    % Update operations for the subgrid.
    %

% Generate the code.
subE_code = my_import('E_simple.cu', 'E', 'subE', 'H', 'subH', 'e', 'sube', ...
    'dx', sg.pitch(1), 'dy', sg.pitch(2), 'dz', sg.pitch(3));
subH_code = my_import('H_simple.cu', 'E', 'subE', 'H', 'subH', ...
    'dx', sg.pitch(1), 'dy', sg.pitch(2), 'dz', sg.pitch(3));

% Insert the update operations.
update({'subEx', 'subEy', 'subEz'}, subE_code, dt, sg_E, 100);
update({'subHx', 'subHy', 'subHz'}, subH_code, dt, sg_E, 101);

    
    %
    % Operation to average between the E-fields of the main- and sub-grid, 
    % which decreases reflections at the sub-grid boundary.
    %

SubGrid_E_avg(prefix, mg, kappa, 102, mg_t + floor(kappa/2)/kappa, ...
    avg_coeff(1));


    %
    % Operations to obtain the boundary h-fields of the subgrid through
    % temporal and spatial interpolation of the main grid H-field values.
    %

% Make the operation that initializes the SG colocated border h-fields.
SubGrid_colocated(prefix, mg, kappa, 102)

% Perform the space interpolation needed to load secondary values into the 
% subgrid border h-fields.
SubGrid_interpolate(prefix, mg, kappa, [103 104]);


    %
    % Average around the border h-fields to increase stability.
    %

SubGrid_H_avg(prefix, sg, [105 106], avg_coeff(2));
 

    %
    % Transfer the subgrid h-values back to the main grid.
    %

SubGrid_transfer(prefix, mg, kappa, 107, mg_t + (kappa-1)/kappa);


    %
    % Secondary main grid H-fields and the operations to update them.
    % These are used for the time interpolation along the subgrid boundary.
    %

SubGrid_secondary(prefix, mg, fieldname, [108 109], mg_t + (kappa-1)/kappa);
