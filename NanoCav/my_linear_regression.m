function [a, b] = my_linear_regression(x, y)

x0 = mean(x);
y_ctr = y - mean(y);
x_ctr = x - mean(x);
a = (x_ctr' * y_ctr) / norm(x_ctr)^2;
b = a * mean(x) - mean(y);

% A = [x, ones(length(x), 1)];
% b = y;
% % z = (A'*A) \ (A'*b);
% z = inv(A'*A) * (A'*b);
% a = z(1)
% b = z(2)
% plot(x, [y, a*x+b]);
