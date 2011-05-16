function SubGrid_transfer(prefix, mg, kappa, step, exec_t)

xyz = 'xyz';
% Transfer all colocated h-fields to the correct main grid H-fields.

% Source code.
source = 'H1(i,j,k) = H2(i+dx,j+dy,k+dz);';

for u = 1 : 3
    fname = ['H', xyz(u)];

    % Correct shift to access sub grid h-fields from main grid locations.
    shift = mg.pitch* 0.5 * (1 - 1/kappa);
    shift(u) = 0;

    % The subgrid has a weird shape, where depending on the component,
    % we need to not copy one slice.
    shape = mg.shape + 1;
    shape(u) = shape(u) - 1;

    offset = mg.offset;
    offset(u) = offset(u) + 1;

    update({fname}, ...
        my_replace(source, 'H1', fname, 'H2', ['sub', fname], ...
        'dx', shift(1), 'dy', shift(2), 'dz', shift(3)), ...
        [], space(offset, shape, mg.pitch), step, exec_t);
end

