function [e] = draw_structure(dims, s, edge_len)
% E = DRAW_STRUCTURE(DIMS, S, EDGE_LEN)
% 
% Description
%     Draw circles or rectangles for epsilon. Takes into account the offsets 
%     in the Yee grid by first doubling and then halving the resolution.
    

% Double our resolution.
dims = 2*dims;

% First build a background of air.
epsilon = ones(dims);
x = (1:dims(1)) ./ 2;
y = (1:dims(2)) ./ 2;
[x, y] = ndgrid (x, y);

% Find the center.
center = [mean(mean(x)) mean(mean(y))];
% center = floor (round(center)/2)*2 + 1; % this makes things more symmetric
center = floor (round(center)/2)*2 + [0.5 0]; % this makes things more symmetric

% draw the structures
for cnt = 1 : length (s)
    if (s{cnt}(1) == 0) % draw circle       
        epsilon = my_draw_circle (center + s{cnt}(2:3), s{cnt}(4), s{cnt}(5), epsilon, x, y, edge_len);
    elseif (s{cnt}(1) == 1) % draw rectangle
        epsilon = my_draw_rectangle (center+s{cnt}(2:3) , s{cnt}(4:5), s{cnt}(6), epsilon, x, y, edge_len);
    else
        error ('could not determine what kind of structure to draw');
    end
end

% Plot ex, ey, and ez.
istart = [2 1 1];
jstart = [1 2 1];
title_text = {'ex', 'ey', 'ez'};
for cnt = 1 : 3
    e{cnt} = epsilon (istart(cnt):2:dims(1), jstart(cnt):2:dims(2));
    subplot (1, 3, cnt)
    imagesc (e{cnt}', [1, 12.25]);
    colormap('gray');
    title(title_text{cnt})
    set (gca, 'YDir', 'normal');
    axis equal tight;

end

% Draw a rectangle.
function [epsilon] = my_draw_rectangle (center, width, eps_rect, epsilon, x, y, edge_length)
xy = {x, y};
for cnt = 1 : 2
    weight{cnt} = (width(cnt)/2 - abs (xy{cnt}-center(cnt)))./edge_length + 1/2;
    weight{cnt} = weight{cnt} .* (weight{cnt} > 0); % bottom caps at 0
    weight{cnt} = (weight{cnt}-1) .* (weight{cnt} < 1) + 1; % top caps at 1
end
w = weight{1}.*weight{2};
epsilon = epsilon .* (1-w) + eps_rect .* w;


% Draw a circle.
function [epsilon] = my_draw_circle (center, radius, eps_circ, epsilon, x, y, edge_length)

r = sqrt ((x-center(1)).^2 + (y - center(2)).^2);

weight = (radius - r)./edge_length + 1/2;
weight = weight .* (weight > 0); % bottom caps at 0
weight = (weight-1) .* (weight < 1) + 1; % top caps at 1

w = weight;
epsilon = epsilon .* (1-w) + eps_circ .* w;



