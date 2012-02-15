function insert_cpml(EH, shape, d_pml, epsilon_eff, dt, exec_t)
% INSERT_CPML(EH, SHAPE, D_PML, EPSILON_EFF, DT, EXEC_T)
%
% Description
%     Inserts the secondary fields for the CPML described in Chapter 7 of
%     Taflove and Hagness, Computational Electrodynamics.

    %
    % Set up constants and helper variables.
    %

% Constants.
m = [3.5, 1]; % Polynomial grading of the pml.

% Calculate the parameter values for the update_Psi operations.
sigma_max = 0.8 * (m(1) + 1) / sqrt(epsilon_eff); 
alpha_max = 0.1 * 0; % Doesn't seem to work for non-zero alpha values.

% Helper variables.
xyz = 'xyz';
ijk = 'ijk';
negpos = {'neg', 'pos'};

% Used to place operations in correct steps.
step1or3 = [1 3];


    % 
    % Loop through and form all necessary fields and operations.
    %

% First, loop through each direction
for u = 2 : 3 % Don't put pml on the x-direction.
    % Determine size of a PML region.
    sub_shape = shape;
    sub_shape(u) = d_pml;

    % Determine the offsets for both polarities.
    offsets = {[0 0 0], [0 0 0]};
    offsets{2}(u) = shape(u) - d_pml;

    % Second, loop through field component directions.
    for v = setdiff(1:3, u) % Only transverse fields need PML.

        % Third, loop through both E and H fields, as well as positive and
        % negative sides (polarity).
        for w = 1 : 2 % For both E and H fields
            for pol = 1 : 2 % For both positive and negative sides.

                % Define the space for the field and update operation.
                sp = space(offsets{pol}, sub_shape);


                    %
                    % Define the field.
                    %

                fieldname = ['Psi_', EH(w), xyz(v), '_', xyz(u), ...
                    '_', negpos{pol}];
                field(fieldname, sp);


                    %
                    % Generate the source code for the update operation.
                    %

                switch [EH(w), xyz(v), '_', xyz(u)]
                    case 'Ex_y'
                        code = '(Hz(i,j,k) - Hz(i,j-1,k))';
                    case 'Ex_z'
                        code = '(Hy(i,j,k) - Hy(i,j,k-1))';
                    case 'Ey_x'
                        code = '(Hz(i,j,k) - Hz(i-1,j,k))';
                    case 'Ey_z'
                        code = '(Hx(i,j,k) - Hx(i,j,k-1))';
                    case 'Ez_x'
                        code = '(Hy(i,j,k) - Hy(i-1,j,k))';
                    case 'Ez_y'
                        code = '(Hx(i,j,k) - Hx(i,j-1,k))';
                    case 'Hx_y'
                        code = '(Ez(i,j+1,k) - Ez(i,j,k))';
                    case 'Hx_z'
                        code = '(Ey(i,j,k+1) - Ey(i,j,k))';
                    case 'Hy_x'
                        code = '(Ez(i+1,j,k) - Ez(i,j,k))';
                    case 'Hy_z'
                        code = '(Ex(i,j,k+1) - Ex(i,j,k))';
                    case 'Hz_x'
                        code = '(Ey(i+1,j,k) - Ey(i,j,k))';
                    case 'Hz_y'
                        code = '(Ex(i,j+1,k) - Ex(i,j,k))';
                    case 'Dx_y'
                        code = '(Bz(i,j,k) - Bz(i,j-1,k))';
                    case 'Dx_z'
                        code = '(By(i,j,k) - By(i,j,k-1))';
                    case 'Dy_x'
                        code = '(Bz(i,j,k) - Bz(i-1,j,k))';
                    case 'Dy_z'
                        code = '(Bx(i,j,k) - Bx(i,j,k-1))';
                    case 'Dz_x'
                        code = '(By(i,j,k) - By(i-1,j,k))';
                    case 'Dz_y'
                        code = '(Bx(i,j,k) - Bx(i,j-1,k))';
                    case 'Bx_y'
                        code = '(Dz(i,j+1,k) - Dz(i,j,k))';
                    case 'Bx_z'
                        code = '(Dy(i,j,k+1) - Dy(i,j,k))';
                    case 'By_x'
                        code = '(Dz(i+1,j,k) - Dz(i,j,k))';
                    case 'By_z'
                        code = '(Dx(i,j,k+1) - Dx(i,j,k))';
                    case 'Bz_x'
                        code = '(Dy(i+1,j,k) - Dy(i,j,k))';
                    case 'Bz_y'
                        code = '(Dx(i,j+1,k) - Dx(i,j,k))';
                end

                if (pol == 1) % Negative polarity.
                    source_code = [fieldname, '(i,j,k) = ', ...
                        'p(', ijk(u), ') * ', fieldname, '(i,j,k) + ', ...
                        'p(', num2str(d_pml), ' + ', ijk(u), ') * ', ...
                        code, ';'];
                else % Positive polarity.
                    ind = [ijk(u), ' - ', num2str(sp.offset(u))];
                    source_code = [fieldname, '(i,j,k) = ', ...
                        'p(', ind ') * ', fieldname, '(i,j,k) + ', ...
                        'p(', num2str(d_pml), ' + ', ind, ') * ', ...
                        code, ';'];
                end


                   %
                   % Determine the parameter list for the update operation.
                   %

                switch [EH(w), '_', negpos{pol}]
                    case {'E_neg', 'D_neg'}
                        x = d_pml : -1 : 1;
                    case {'H_neg', 'B_neg'}
                        x = d_pml-0.5 : -1 : 0.5;
                    case {'H_pos', 'B_pos'}
                        x = 1 : d_pml;
                    case {'E_pos', 'D_pos'}
                        x = 0.5 : d_pml-0.5;
                end
                params = my_params(x, sigma_max, alpha_max, dt, d_pml, m);


                    % 
                    % Write the update operation.
                    %

                update({fieldname}, source_code, params, sp, ...
                    step1or3(w), exec_t);

            end
        end
    end
end

function [params] = my_params(x, sigma_max, alpha_max, dt, d_pml, m)
% Calculate relevant parameters for the PML material.
sigma = (x/d_pml).^m(1) * sigma_max;
alpha = ((d_pml-x)/d_pml).^m(2) * alpha_max;
params(1,:) = exp(-(sigma + alpha) * dt);
params(2,:) = sigma / (sigma + alpha) * (exp(-(sigma + alpha) * dt) - 1);
params = params';
params = params(:);
