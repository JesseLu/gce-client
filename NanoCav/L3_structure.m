function [ex, ey, ez] = shifted_L3_structure (grid_size, d_pml, ...
    a, d, shift, radius)
% [EX, EY, EZ] = SHIFTED_L3_STRUCTURE (GRID_SIZE, D_PML, A, D, SHIFT, RADIUS)
%
% Description
%     Constructs a shifted L3 nanophotonic resonator in silicon. The 
%     structure produced is that of a full slab, no symmetries are imposed.
% 
% Outputs
%     EX, EY, EZ: Three arrays containing the values of the x, y, and z 
%     components of epsilon.

% Constants.
eps_Si = 12.25;
eps_air = 1.0;
edge_len = 2;

% Determine the other parameters related to a.
r = radius * a;

% === First make the two-dimensional structure ===
% Lattice directions. I use two interleaved rectangular axes to form the
% triangular lattice.
ax = a;
ay = a*sqrt(3);

% Cover the slab with silicon first.
s = {[1 0 0 1e9 1e9 eps_Si]}; 

% Describe the "off-center" rectangular grid of holes.
lim = floor((grid_size(1:2)./2 - r - d_pml)./[ax ay] - 0.5) + 0.5;
for i = -lim(1) : lim(1)
    for j = -lim(2) : lim(2)
        s{end+1} = [0 i*ax j*ay r 1.0];
    end
end

% Describe the centered rectangular grid of holes.
lim = floor((grid_size(1:2)./2 - r - d_pml)./[ax ay]);
for i = -lim(1) : lim(1)
    for j = -lim(2) : lim(2)
        if (j == 0)
            switch i
                case {-1, 0, 1}
                    % No hole.
                case {-2, 2}
                    dx = sign(i) * ax * shift;
                    s{end+1} = [0 i*ax+dx j*ay r eps_air];
                otherwise
                    s{end+1} = [0 i*ax j*ay r eps_air];
            end
        else 
            s{end+1} = [0 i*ax j*ay r 1.0];
        end
    end
end

% Obtain the 2D epsilon arrays.
e = draw_structure(grid_size(1:2), s, edge_len);

% === Now, make the 2D structure into a 3D structure. ===
center = round(grid_size(3)/2);
t_slab = d * a;

% Create the slab. Be careful of offsets in the Yee grid, and smoothing.
offsets = [0 0 0.5];
for k = 1 : 3
    z = offsets(k) + [1 : grid_size(3)];

    % Make the weighting function.
    w = (t_slab/2 - abs(z - center)) / edge_len;
    w = 1 * (w > 0.5) + (w+0.5) .* ((w>-0.5) & (w <= 0.5));
    % plot(w, '.-'); pause;

    % Apply the weighting function.
    epsilon{k} = zeros(grid_size);
    for m = 1 : grid_size(3)
        epsilon{k}(:,:,m) = (1-w(m)) * eps_air + w(m) * e{k};
    end
end

ex = epsilon{1};
ey = epsilon{2};
ez = epsilon{3};

% % Use this to step through the slices of the structure, for verification.
% for k = 1 : grid_size(3)
%     for cnt = 1 : 3
%         subplot (1, 3, cnt)
%         imagesc (epsilon{cnt}(:,:,k)', [1, 12.25]);
%         colormap('gray');
%         title(num2str(k));
%         set (gca, 'YDir', 'normal');
%         axis equal tight;
%     end
%     pause
% end
