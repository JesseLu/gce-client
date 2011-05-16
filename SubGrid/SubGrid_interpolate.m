function SubGrid_interpolate(prefix, mg, kappa, steps);

for u = 1 : 3 % Loop over all the faces.
    for c = setdiff(1:3, u) % Iterate over field components (tangential only).
        for pol = 1 : 2 % Iterate over polarities.
            d = [c, setdiff(1:3, [u, c])];
            for k = 1 : length(d) % Loop over spreading directions.
                make_op(mg.offset, mg.shape, mg.pitch, ...
                    prefix, kappa, c, u, pol, d(k), steps(k));
                % write_operation(filename, op);
            end
        end
    end
end

function make_op(mg_offset, mg_shape, mg_spacing, ...
    prefix, kappa, comp, face, pol, dir, step)

% Used for naming.
xyz = 'xyz';
negpos = {'neg', 'pos'};

% Names.
fieldname = [prefix, 'H', xyz(comp)]; % Name of the field to be updated.
suffix = ['_', xyz(face), negpos{pol}, '_spread', xyz(dir)];


% Offset. Note that we actually start "below" the subgrid.
offset = mg_offset + 0.5 * mg_spacing * (1 - 1/kappa); 
offset(comp) = mg_offset(comp); % Weirdness of the shifts in the 3D Yee cell.
if (pol == 2) % Positive polarity.
    offset(face) = offset(face) + mg_shape(face);
end

% The nonspread-ing and non-face direction
other_dir = setdiff(1:3, [face, dir]);

% Shape.
% shape = mg_shape;
shape(face) = 1;
shape(dir) = mg_shape(dir) + 1;
shape(other_dir) = (mg_shape(other_dir) + 1) * kappa;

shape = mg_shape + 1;
if (dir == comp) % Same direction spread.
    shape(face) = 1;
    shape(comp) = mg_shape(comp) + 1;
    shape(other_dir) = mg_shape(other_dir) * kappa + 1;
else % Perpendicular spread.
    shape(face) = 1;
    shape(comp) = (mg_shape(comp) + 1) * kappa + 1;
    shape(dir) = mg_shape(dir);
end

% Spacing.
spacing = mg_spacing;
spacing(other_dir) = mg_spacing(other_dir) / kappa;

% Form the operation.
update({fieldname}, code_gen(prefix, comp, dir, mg_spacing, kappa), ...
    [], space(offset, shape, spacing), step);


function [source] = code_gen(prefix, field_comp, interp_dir, ...
    mg_spacing, kappa)

xyz = 'xyz';
fieldname = [prefix, 'H',  xyz(field_comp)];

step = [0 0 0];
step(interp_dir) = 1;

% offset = [-0.5 -0.5 -0.5];
% offset(field_comp) = 0.0;

source = '';

    %
    % Generate code.
    %

% Code to load in the fields that will be interpolated between.
template= ...
    'float fnum = field(i + (dx), j + (dy), k + (dz));\r';

for num = 0 : 1
    shift = num * step;
    source = [source, my_replace(template, ...
        'num', num, ...
        'field', fieldname, ...
        'dx', shift(1), ...
        'dy', shift(2), ...
        'dz', shift(3))];
end

% Code that performs the interpolation.
template = 'field(i + (dx), j + (dy), k + (dz)) = p0 * f0 + p1 * f1;\r';

for k = 1 : kappa-1
    shift = k/kappa * step;
    source = [source, my_replace(template, ...
        'field', fieldname, ...
        'dx', shift(1), ...
        'dy', shift(2), ...
        'dz', shift(3), ...
        'p0', (1 - k/kappa), ...
        'p1', k/kappa)];
end
