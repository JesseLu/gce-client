float Hx_curl = (Ez(i,j+1,k)-Ez(i,j,k)) - (Ey(i,j,k+1)-Ey(i,j,k));
float Hy_curl = (Ex(i,j,k+1)-Ex(i,j,k)) - (Ez(i+1,j,k)-Ez(i,j,k));
float Hz_curl = (Ey(i+1,j,k)-Ey(i,j,k)) - (Ex(i,j+1,k)-Ex(i,j,k));

if (i < d_pml) {
    Hy_curl -= Psi_Hy_x_neg(i,j,k);
    Hz_curl += Psi_Hz_x_neg(i,j,k);
}
if (j < d_pml) {
    Hx_curl += Psi_Hx_y_neg(i,j,k);
    Hz_curl -= Psi_Hz_y_neg(i,j,k);
}
if (k < d_pml) {
    Hx_curl -= Psi_Hx_z_neg(i,j,k);
    Hy_curl += Psi_Hy_z_neg(i,j,k);
}
if (i > xx - d_pml - 1) {
    Hy_curl -= Psi_Hy_x_pos(i,j,k);
    Hz_curl += Psi_Hz_x_pos(i,j,k);
}
if (j > yy - d_pml - 1) {
    Hx_curl += Psi_Hx_y_pos(i,j,k);
    Hz_curl -= Psi_Hz_y_pos(i,j,k);
}
if (k > zz - d_pml - 1) {
    Hx_curl -= Psi_Hx_z_pos(i,j,k);
    Hy_curl += Psi_Hy_z_pos(i,j,k);
}

Hx(i,j,k) -= p(0) * Hx_curl;
Hy(i,j,k) -= p(0) * Hy_curl;
Hz(i,j,k) -= p(0) * Hz_curl;
