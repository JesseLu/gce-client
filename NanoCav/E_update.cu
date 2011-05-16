float Ex_curl = (Hz(i,j,k)-Hz(i,j-1,k)) - (Hy(i,j,k)-Hy(i,j,k-1));
float Ey_curl = (Hx(i,j,k)-Hx(i,j,k-1)) - (Hz(i,j,k)-Hz(i-1,j,k));
float Ez_curl = (Hy(i,j,k)-Hy(i-1,j,k)) - (Hx(i,j,k)-Hx(i,j-1,k));

if (i < d_pml) {
    Ey_curl -= Psi_Ey_x_neg(i,j,k);
    Ez_curl += Psi_Ez_x_neg(i,j,k);
}
if (i > xx - d_pml - 1) {
    Ey_curl -= Psi_Ey_x_pos(i,j,k);
    Ez_curl += Psi_Ez_x_pos(i,j,k);
}
if (j < d_pml) {
    Ex_curl += Psi_Ex_y_neg(i,j,k);
    Ez_curl -= Psi_Ez_y_neg(i,j,k);
}
if (j > yy - d_pml - 1) {
    Ex_curl += Psi_Ex_y_pos(i,j,k);
    Ez_curl -= Psi_Ez_y_pos(i,j,k);
}
if (k < d_pml) {
    Ex_curl -= Psi_Ex_z_neg(i,j,k);
    Ey_curl += Psi_Ey_z_neg(i,j,k);
}
if (k > zz - d_pml - 1) {
    Ex_curl -= Psi_Ex_z_pos(i,j,k);
    Ey_curl += Psi_Ey_z_pos(i,j,k);
}

Ex(i,j,k) += (p(0) / ex(i,j,k)) * Ex_curl;
Ey(i,j,k) += (p(0) / ey(i,j,k)) * Ey_curl;
Ez(i,j,k) += (p(0) / ez(i,j,k)) * Ez_curl;
