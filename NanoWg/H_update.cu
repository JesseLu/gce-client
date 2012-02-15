float Hx_curl = (Ez(i,j+1,k)-Ez(i,j,k)) - (Ey(i,j,k+1)-Ey(i,j,k));
float Hy_curl = (Ex(i,j,k+1)-Ex(i,j,k)) - (Ez(i+1,j,k)-Ez(i,j,k));
float Hz_curl = (Ey(i+1,j,k)-Ey(i,j,k)) - (Ex(i,j+1,k)-Ex(i,j,k));

float Bx_curl = (Dz(i,j+1,k)-Dz(i,j,k)) - (Dy(i,j,k+1)-Dy(i,j,k));
float By_curl = (Dx(i,j,k+1)-Dx(i,j,k)) - (Dz(i+1,j,k)-Dz(i,j,k));
float Bz_curl = (Dy(i+1,j,k)-Dy(i,j,k)) - (Dx(i,j+1,k)-Dx(i,j,k));
/*
if (i > (float)(xx-1.5)) {
    Hy_curl = (Ex(i,j,k+1)-Ex(i,j,k)) - ((p(1)*Ez((float)0,j,k)-p(2)*Dz((float)0,j,k))-Ez(i,j,k));
    Hz_curl = ((p(1)*Ey((float)0,j,k)-p(2)*Dy((float)0,j,k))-Ey(i,j,k)) - (Ex(i,j+1,k)-Ex(i,j,k));

    By_curl = (Dx(i,j,k+1)-Dx(i,j,k)) - ((p(2)*Ez((float)0,j,k)+p(1)*Dz((float)0,j,k))-Dz(i,j,k));
    Bz_curl = ((p(2)*Ey((float)0,j,k)+p(1)*Dy((float)0,j,k))-Dy(i,j,k)) - (Dx(i,j+1,k)-Dx(i,j,k));
}
*/

/*if (i < d_pml) {
    Hy_curl -= Psi_Hy_x_neg(i,j,k);
    Hz_curl += Psi_Hz_x_neg(i,j,k);
}*/
/*if (i > xx - d_pml - 1) {
    Hy_curl -= Psi_Hy_x_pos(i,j,k);
    Hz_curl += Psi_Hz_x_pos(i,j,k);
}*/
/*
if (j < d_pml) {
    Hx_curl += Psi_Hx_y_neg(i,j,k);
    Hz_curl -= Psi_Hz_y_neg(i,j,k);
}
if (k < d_pml) {
    Hx_curl -= Psi_Hx_z_neg(i,j,k);
    Hy_curl += Psi_Hy_z_neg(i,j,k);
}
if (j > yy - d_pml - 1) {
    Hx_curl += Psi_Hx_y_pos(i,j,k);
    Hz_curl -= Psi_Hz_y_pos(i,j,k);
}
if (k > zz - d_pml - 1) {
    Hx_curl -= Psi_Hx_z_pos(i,j,k);
    Hy_curl += Psi_Hy_z_pos(i,j,k);
}

if (j < d_pml) {
    Bx_curl += Psi_Bx_y_neg(i,j,k);
    Bz_curl -= Psi_Bz_y_neg(i,j,k);
}
if (k < d_pml) {
    Bx_curl -= Psi_Bx_z_neg(i,j,k);
    By_curl += Psi_By_z_neg(i,j,k);
}
if (j > yy - d_pml - 1) {
    Bx_curl += Psi_Bx_y_pos(i,j,k);
    Bz_curl -= Psi_Bz_y_pos(i,j,k);
}
if (k > zz - d_pml - 1) {
    Bx_curl -= Psi_Bx_z_pos(i,j,k);
    By_curl += Psi_By_z_pos(i,j,k);
}
*/
Hx(i,j,k) = Hx(i,j,k) - p(0) * Hx_curl;
Hy(i,j,k) = Hy(i,j,k) - p(0) * Hy_curl;
Hz(i,j,k) = Hz(i,j,k) - p(0) * Hz_curl;

Bx(i,j,k) = Bx(i,j,k) - p(0) * Bx_curl;
By(i,j,k) = By(i,j,k) - p(0) * By_curl;
Bz(i,j,k) = Bz(i,j,k) - p(0) * Bz_curl;
