function SubGrid_H_avg(prefix, sg, steps, coeff)

xyz = 'xyz';
negpos = {'neg', 'pos'};

code = 'subH(i,j,k) = p(0) * subH(i,j,k) + (1-p(0)) * 0.5 * (subH(i-dx,j-dy,k-dz) + subH(i+dx,j+dy,k+dz));';

for c = 1 : 3 % Loop over tangential fields.
    k = 1;
    for u = setdiff(1:3, c)  % Loop over faces.
        step = steps(k);
        k = k + 1;
        for pol = 1 : 2 % Loop over polarities.
            fname = [prefix, 'H', xyz(c)];

            shift = [0 0 0];
            shift(u) = sg.pitch(u);

            shape = sg.shape - 2;
            shape(u) = 1;
            shape(c) = sg.shape(c) - 1;

            offset = sg.offset + sg.pitch;
            if (pol == 2) % Positive polarity.
                offset(u) = sg.offset(u) + sg.pitch(u) * (sg.shape(u) - 2);
            end

            update({fname}, ...
                my_replace(code, 'subH', fname, ...
                'dx', shift(1), 'dy', shift(2), 'dz', shift(3)), ...
                coeff, space(offset, shape, sg.pitch), step);
            % write_operation(filename, op);
        end
    end
end
