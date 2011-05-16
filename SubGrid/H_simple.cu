float Hx_curl = (Ez(i,j+dy,k)-Ez(i,j,k)) - (Ey(i,j,k+dz)-Ey(i,j,k));
float Hy_curl = (Ex(i,j,k+dz)-Ex(i,j,k)) - (Ez(i+dx,j,k)-Ez(i,j,k));
float Hz_curl = (Ey(i+dz,j,k)-Ey(i,j,k)) - (Ex(i,j+dy,k)-Ex(i,j,k));

Hx(i,j,k) -= p(0) * Hx_curl;
Hy(i,j,k) -= p(0) * Hy_curl;
Hz(i,j,k) -= p(0) * Hz_curl;
/*
Hx(i,j,k) = 1.0;
Hy(i,j,k) = 1.0;
Hz(i,j,k) = 1.0;
*/
