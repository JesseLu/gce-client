function insert_poynting_box(box_name, box_offset, box_shape, step, exec_t)
% INSERT_POYNTING_BOX(BOX_NAME, BOX_OFFSET, BOX_SHAPE, STEP, EXEC_T)
%
% Description
%     Calculates the power emanating from the 6 faces of a box.

    %
    % Integration functions for the three cardinal directions.
    %

codes{1} = '0.5 * (Ey(i,j,k) * (Hz(i,j,k) + Hz(i-1,j,k)) - Ez(i,j,k) * (Hy(i,j,k) + Hy(i-1,j,k)));';
codes{2} = '0.5 * (Ez(i,j,k) * (Hx(i,j,k) + Hx(i,j-1,k)) - Ex(i,j,k) * (Hz(i,j,k) + Hz(i,j-1,k)));';
codes{3} = '0.5 * (Ex(i,j,k) * (Hy(i,j,k) + Hy(i,j,k-1)) - Ey(i,j,k) * (Hx(i,j,k) + Hx(i,j,k-1)));';


    %
    % Helper variables.
    %

negpos = {'neg', 'pos'};
xyz = 'xyz';
minusplus = {'-1 * ', '+1 * '};

    
    %
    % Loop through the six faces of a cube.
    %

for u = 1 : 3 % First, loop through each direction
    % Determine the offsets for both polarities.
    offsets = {box_offset, box_offset};
    offsets{2}(u) = box_offset(u) + box_shape(u) - 1;

    % Determine the shapes.
    shape = box_shape;
    shape(u) = 1;

    for pol = 1 : 2 % Loop across both positive and negative sides.

            %
            % Define global fields and operations.
            %

        global_name = [box_name, '_', xyz(u), negpos{pol}];
        global_field(global_name);

        integrate(global_name, [minusplus{pol}, codes{u}], [], ...
            space(offsets{pol}, shape), step, exec_t)
    end
end
