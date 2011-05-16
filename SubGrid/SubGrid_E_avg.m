function SubGrid_E_avg(prefix, mg, kappa, step, iters, coeff)

xyz = 'xyz';
ijk = 'ijk';

source = '';

for c = 1 : 3 % Iterate through all components of the E-field.
    shift = [0 0 0];
    shift(c) = mg.pitch(c) * 0.5 * (1 - 1/kappa);

    u = setdiff(1:3, c);

    % Limits.
    neg = mg.offset + 1.5 * mg.pitch;
    pos = mg.offset + (mg.shape - 1.5) .* mg.pitch;

    source = [source, my_import('sube_avg.cu', ...
        'E', ['E', xyz(c)], 'sube', ['subE', xyz(c)], ...
        'sx', shift(1), 'sy', shift(2), 'sz', shift(3), ... 
        'A', ijk(u(1)), 'aneg', neg(u(1)), 'apos', pos(u(1)), ...
        'B', ijk(u(2)), 'bneg', neg(u(2)), 'bpos', pos(u(2)))];
end

update({'Ex', 'Ey', 'Ez', 'subEx', 'subEy', 'subEz'}, source, coeff, ...
    space(mg.offset+1, mg.shape), step, iters);

