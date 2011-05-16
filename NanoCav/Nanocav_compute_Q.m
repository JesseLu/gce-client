function [Q] = NanoCav_compute_Q (filename, t_cutoff, f)
% Q = NANOCAV_COMPUTE_Q (FILENAME, T_CUTOFF, F)
% 
% Description
%     Calculate the relevant quality factors using both an energy-decay and
%     energy over power models.

    % 
    % Extract the simulation data.
    % 

% Time discretization.
dt = (0.99 / sqrt(3));

% Extract energy.
energy = hdf5read(filename, 'fields/energy');

% Extract power.
name = {'box_bot', 'box_mid', 'box_top'};
for j = 1 : length(name)
    pow = {'_xneg', '_xpos', '_yneg', '_ypos'};
    switch j
        case 1
            pow = [pow {'_zneg'}];
        case 3
            pow = [pow {'_zpos'}];
    end
            
    for k = 1 : length(pow)
        % Normalize to change in evergy over a second (unit time).
        p(:,k) = 1/dt * hdf5read(filename, ['fields/', name{j}, pow{k}]);
    end
    power(:,j) = sum(p, 2);
end

% Trim!
t = dt * [0 : length(energy)-1];
cut_ind = max([1, round(t_cutoff / dt)]);
t = t(cut_ind:end);
energy = energy(cut_ind:end);
power = power(cut_ind:end, :);

    %
    % Fit the data.
    % 

% Get the fit to the total energy, and total power.
figure(f(1))
subplot 211; [A_energy, alpha, B, omega] = my_fit2('Total energy', t, energy);
subplot 212; A_power = my_fit2('Total power', t, sum(power, 2), alpha, omega);

% Fit the partial powers.
figure(f(2))
for k = 1 : 3
    subplot(3, 1, k);
    A(k) = my_fit2(['Power(', name{k}, ')'], t, power(:,k), alpha, omega);
end

    %
    % Determine Q-factors and print out results.
    %

% Calculate and compare Q's.
omega = 1/2 * omega; % Factor of 0.5 from sin^2.
Q_energy = omega / alpha;
Q_power = omega * A_energy / A_power;
Q_mean = mean([Q_energy, Q_power]);

% Calculate beta: the ratio of the vertical Q to the overall Q.
% e.g. beta = 1 means that all the power is lost vertically.
beta = (A(1) + A(3)) / sum(A); 

% Print out results.
fprintf('\n=== Results\n');
fprintf('Fitted frequency: %1.6f\n', omega);
fprintf('Total Q from energy decay (Q_energy): %e\n', Q_energy);
fprintf('Total Q from energy:power ratio (Q_power): %e\n', Q_power);
fprintf('Loss directionality (1 = all vertical losses, 0 = all in-plane losses): %1.6f\n', beta);
fprintf('Mean total Q ((Q_energy + Q_power)/2): %e\n', Q_mean);
fprintf('Deviation from mean ((Q_mean - Q_x)/Q_mean): %e\n', ...
    (Q_mean - Q_energy) / Q_mean);
fprintf('Calculated Q_in-plane: %e\n', Q_mean / (1-beta));
fprintf('Calculated Q_vertical: %e\n', Q_mean / (beta));
fprintf('\n');
