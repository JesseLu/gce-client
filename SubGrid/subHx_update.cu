float Hx0 = Hx(i,j,k) - \
    p(0) * ((Ez(i,j+dy,k)-Ez(i,j,k)) - (Ey(i,j,k+dz)-Ey(i,j,k)));

float Hx1 = 0;

Hx(i,j,k) = Hx0;
