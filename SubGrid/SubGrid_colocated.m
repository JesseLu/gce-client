function SubGrid_colocated(prefix, mg, kappa, step)

for face = 1 : 3 % Iterate over faces
    comp = 1 : 3;
    comp(face) = [];
    for c = comp % Iterate over field components (tangential only).
        for pol = 1 : 2 % Iterate over polarities.
            make_op(mg.offset, mg.shape, mg.pitch, ...
                prefix, kappa, c, face, pol, step);
            % write_operation(filename, op);
            % op.source_code
        end
    end
end

function make_op(mg_offset, mg_shape, mg_spacing, ...
    prefix, kappa, comp, face, pol, step)
xyz = 'xyz';
negpos = {'neg', 'pos'};

fieldname = ['H', xyz(comp)]; % Determine the name of the field to update.

% The appropriate shift so that we update the correct SG field.
shift = 0.5 * (1 - (1/kappa)) * mg_spacing;
shift(comp) = 0;

% Move in the face direction to stabilize subgrid code.
move = [0 0 0];
move(face) = mg_spacing(face) / kappa * ((pol == 1) - (pol == 2));

s1 = shift + move;
s2 = shift + 2 * move;

% Generate the source code.
source = my_import('time_interp.cu',    'H', fieldname, ...
    'kappa_inv', 1/kappa, ...
    'dx', shift(1), 'dy', shift(2), 'dz', shift(3), ...
    'sx1', s1(1), 'sy1', s1(2), 'sz1', s1(3), ...
    'sx2', s2(1), 'sy2', s2(2), 'sz2', s2(3));
suffix = ['_', xyz(face), negpos{pol}];

shape = mg_shape + 2;
shape(face) = 1;

% Importantly, here we are iterating over the main grid points. 
% That is to say, the offset for the operations is identical to that of the MG.
offset = mg_offset;
if (pol == 2) % Positive polarity.
    offset(face) = offset(face) + mg_shape(face);
end

update({[prefix, fieldname]}, source, [], space(offset, shape, mg_spacing), ...
    step);
