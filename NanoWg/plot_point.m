function [] = plot_point(point_output, w_center, t_cutoff, dt)
% PLOT_POINT(POINT_OUTPUT, W_CENTER, T_CUTOFF, DT)
% 
% Description
%     Plots the time variation of a recording of the field values at a point.
%     Also plots the amplitude of its Fourier transform.

% % Get the point field data.
% f = squeeze(hdf5read(filename, dset_name));
f = point_output;

% Calculate the time and frequency axes.
% dt = 0.99 / sqrt(3);
t = (0 : length(f)-1) * dt;

% Truncate the time data.
ind = round(max([1 t_cutoff/dt]));
t = t(ind:end);
f = f(ind:end);

% Calculate the frequency data.
F = abs(fft(f));

% Calculate the cutoff for frequency.
dw = 2 * pi / (dt * length(f));
w = (0 : length(f)-1) * dw;
ind = round(2 * w_center / dw);

% Trim frequency data.
w = w(1:ind);
F = F(1:ind);

% Plot.
subplot 211; plot(t, f); xlabel('time');
subplot 212; plot(w, F); xlabel('\omega (2\pi/a)');

