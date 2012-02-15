float Ex_curl = (Hz(i,j,k)-Hz(i,j-1,k)) - (Hy(i,j,k)-Hy(i,j,k-1));
float Ey_curl = (Hx(i,j,k)-Hx(i,j,k-1)) - (Hz(i,j,k)-Hz(i-1,j,k));
float Ez_curl = (Hy(i,j,k)-Hy(i-1,j,k)) - (Hx(i,j,k)-Hx(i,j-1,k));

float Dx_curl = (Bz(i,j,k)-Bz(i,j-1,k)) - (By(i,j,k)-By(i,j,k-1));
float Dy_curl = (Bx(i,j,k)-Bx(i,j,k-1)) - (Bz(i,j,k)-Bz(i-1,j,k));
float Dz_curl = (By(i,j,k)-By(i-1,j,k)) - (Bx(i,j,k)-Bx(i,j-1,k));

/*
if (i < (float)(0.5)) {
    float Ey_curl = (Hx(i,j,k)-Hx(i,j,k-1)) - (Hz(i,j,k)-(p(1)*Hz((float)(xx-1),j,k)-p(2)*Bz((float)(xx-1),j,k)));
    float Ez_curl = (Hy(i,j,k)-(p(1)*Hy((float)(xx-1),j,k)-p(2)*By((float)(xx-1),j,k))) - (Hx(i,j,k)-Hx(i,j-1,k));

    float Dy_curl = (Bx(i,j,k)-Bx(i,j,k-1)) - (Bz(i,j,k)-(p(2)*Hz((float)(xx-1),j,k)+p(1)*Bz((float)(xx-1),j,k)));
    float Dz_curl = (By(i,j,k)-(p(2)*Hy((float)(xx-1),j,k)+p(1)*By((float)(xx-1),j,k))) - (Bx(i,j,k)-Bx(i,j-1,k));
}
*/
/*if (i < d_pml) {
    Ey_curl -= Psi_Ey_x_neg(i,j,k);
    Ez_curl += Psi_Ez_x_neg(i,j,k);
}
if (i > xx - d_pml - 1) {
    Ey_curl -= Psi_Ey_x_pos(i,j,k);
    Ez_curl += Psi_Ez_x_pos(i,j,k);
}*/
/*
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

if (j < d_pml) {
    Dx_curl += Psi_Dx_y_neg(i,j,k);
    Dz_curl -= Psi_Dz_y_neg(i,j,k);
}
if (j > yy - d_pml - 1) {
    Dx_curl += Psi_Dx_y_pos(i,j,k);
    Dz_curl -= Psi_Dz_y_pos(i,j,k);
}
if (k < d_pml) {
    Dx_curl -= Psi_Dx_z_neg(i,j,k);
    Dy_curl += Psi_Dy_z_neg(i,j,k);
}
if (k > zz - d_pml - 1) {
    Dx_curl -= Psi_Dx_z_pos(i,j,k);
    Dy_curl += Psi_Dy_z_pos(i,j,k);
}*/

Ex(i,j,k) = Ex(i,j,k) + (p(0) / ex(i,j,k)) * Ex_curl;
Ey(i,j,k) = Ey(i,j,k) + (p(0) / ey(i,j,k)) * Ey_curl;
Ez(i,j,k) = Ez(i,j,k) + (p(0) / ez(i,j,k)) * Ez_curl;

Dx(i,j,k) = Dx(i,j,k) + (p(0) / ex(i,j,k)) * Dx_curl;
Dy(i,j,k) = Dy(i,j,k) + (p(0) / ey(i,j,k)) * Dy_curl;
Dz(i,j,k) = Dz(i,j,k) + (p(0) / ez(i,j,k)) * Dz_curl;
