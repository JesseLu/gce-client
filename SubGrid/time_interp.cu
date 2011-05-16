float v = fmodf(t, 1.0) + kappa_inv;
subH(i + (dx), j + (dy), k + (dz)) = H_d0(i,j,k) + \
    (v/2.0) * (H(i,j,k) - H_d1(i,j,k)) + \
    (powf(v, 2.0)/2.0) * (H(i,j,k) - 2.0 * H_d0(i,j,k) + H_d1(i,j,k));

