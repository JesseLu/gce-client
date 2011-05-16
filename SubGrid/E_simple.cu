float Ex_curl = (Hz(i,j,k)-Hz(i,j-dy,k)) - (Hy(i,j,k)-Hy(i,j,k-dz));
float Ey_curl = (Hx(i,j,k)-Hx(i,j,k-dz)) - (Hz(i,j,k)-Hz(i-dx,j,k));
float Ez_curl = (Hy(i,j,k)-Hy(i-dx,j,k)) - (Hx(i,j,k)-Hx(i,j-dy,k));

Ex(i,j,k) += (p(0) / ex(i,j,k)) * Ex_curl;
Ey(i,j,k) += (p(0) / ey(i,j,k)) * Ey_curl;
Ez(i,j,k) += (p(0) / ez(i,j,k)) * Ez_curl;
