function SubGrid_secondary(prefix, mg, fieldname, steps, exec_t)

% Need extra an extra layer on all sides for the spatial interpolation later.
sec_shape = mg.shape + 2;

% Secondary fields for time interpolation.
% Create the main grid H-fields needed to time-interpolate the colocated
% LG boundary h-fields.
suffix = {'_d0', '_d1'};
for k = 4 : 6
    for l = 1 : length(suffix)
        field([fieldname{k} suffix{l}], ...
            space(mg.offset, sec_shape, mg.pitch));
    end
end

    %
    % Create the functions that will update these fields.
    %

% Source code.
source = [  'Hx1(i,j,k) = Hx2(i,j,k);\r', ...
            'Hy1(i,j,k) = Hy2(i,j,k);\r', ...
            'Hz1(i,j,k) = Hz2(i,j,k);\r'];

% Update the time N-1 secondary field.
update({'Hx_d1', 'Hy_d1', 'Hz_d1'}, ...
    my_replace(source, '1', '_d1', '2', '_d0'), [], ...
    space(mg.offset, sec_shape), steps(1), exec_t);

% Update the time N secondary field.
update({'Hx_d0', 'Hy_d0', 'Hz_d0'}, ...
    my_replace(source, '1', '_d0', '2', ''), [], ...
    space(mg.offset, sec_shape), steps(2), exec_t);



