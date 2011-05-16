function [A, alpha, B, freq, phase, percent_error] = ...
    my_fit2 (title_text, x, y_meas, varargin)
% [A, ALPHA, B, FREQ, PHASE, PERCENT_ERROR] = ...
%     MY_FIT2 (TITLE_TEXT, X, Y_MEAS, VARARGIN)
% 
% Description
%     Fit data to a custom exponentially-decreasing sinusoid model.

fprintf(['Fitting ', title_text, '...\n']);

if (isempty(varargin))
    fitall = true;
else
    fitall = false;
end

% Get everything in order.
N = length(y_meas);
x = x(:);
y_meas = y_meas(:);

%
% Fit to exponential.
% 

if (fitall)
    [a, b] = my_linear_regression(x, log(y_meas));
    A = exp(-b);
    alpha = -a;
else % Set alpha and omega, fit for other parameters only.
    alpha = varargin{1};
    freq = varargin{2};
    A = exp(mean(log(y_meas)) + alpha * mean(x));
end

%
% Remove exponential component and fit the sinusoidal component.
%

y_sin = (y_meas ./ exp(-alpha*x)) - A;

% Find the zero-crossings.
y0 = y_sin(1:end-1);
y1 = y_sin(2:end);

% Crossings with positive slope.
ind = find ((y0 <= 0) & (y1 >= 0));
x_cross_pos = x(ind) + (y0(ind) ./ (y0(ind) - y1(ind)));

% Crossings with negative slope.
ind = find((y0 >= 0) & (y1 <= 0)); 
x_cross_neg = x(ind) + (y0(ind) ./ (y0(ind) - y1(ind)));

% Perform linear regression to find frequency and phase.
x_cross = [x_cross_pos; x_cross_neg];
if (min(x_cross_pos) < min(x_cross_neg))
    y_cross = 2 * pi * [0:length(x_cross_pos)-1, 0.5:length(x_cross_neg)-0.5]'; 
else
    y_cross = 2 * pi * [1:length(x_cross_pos), 0.5:length(x_cross_neg)-0.5]'; 
end
if (fitall)
    [freq, phase] = my_linear_regression(x_cross, y_cross);
else
    phase = freq * mean(x_cross) - mean(y_cross);
end

% Simple regression to find amplitude.
sin_model = sin(freq * x - phase);
B = (sin_model' * y_sin) / norm(sin_model)^2;

%
% Put together the model and do a local optimization of the fit.
%

% Functions to calculate the fit and its error.
y_fun = @(p) (p(1)  + p(3) * sin(p(4) * x - p(5))) .* exp(-p(2) * x);
error_fun = @(p) 100 * (1 / sqrt(N)) * norm((y_meas - y_fun(p)) ./ y_meas);

% Local optimization.
p0 = double([A, alpha, B, freq, phase]);
options = optimset('MaxFunEvals', 1e5);
if (isempty(varargin))
    p = fminsearch(error_fun, p0, options);
else
    % Don't fit for alpha.
    p = fminsearch(@(p) error_fun([p(1), alpha, p(2), freq, p(3)]), ...
        [p0([1 3 5])], options);
    p = [p(1), alpha, p(2), freq, p(3)];
end

% 
% Plot and model parameters as well as percent error.
%

% Plot measured and model values against one another.
y_model = y_fun(p);
percent_error = error_fun(p);
plot(x, y_meas, 'b.-', x, y_model, 'r.');
title(sprintf('%s (error: %1.5f%%)', strrep(title_text, '_', ' '), percent_error));

% Return final parameters.
A = p(1);
alpha = p(2);
B = p(3);
freq = p(4);
phase = p(5);
