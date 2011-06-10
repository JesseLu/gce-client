function thermal_plot(filename)
% Retrieve 
s = squeeze(hdf5read(filename, 'fields/slice'));

subplot 111
m = max(abs(s(:))) + eps;
for k = 1 : size(s,3)
    imagesc(s(:,:,k), m/10 * [-1 1]);
    title(num2str(k));
    axis equal tight;
    set(gca, 'Ydir', 'normal');
    drawnow
    pause(0.1);
end

slice = s(:,:,k);
