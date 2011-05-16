float Hy0 = Hy(i,j,k) - \
    p(0) * ((Ex(i,j,k+dz)-Ex(i,j,k)) - (Ez(i+dx,j,k)-Ez(i,j,k)));

float Hy1 = 0;
float cnt = 0.0;

if ((i < ineg) | ( i > ipos)) {
    Hy1 += Hy(i-dx,j,k) + Hy(i+dx,j,k);
    cnt += 2;
}
if ((k < kneg) | ( k > kpos)) {
    Hy1 += Hy(i,j-dy,k) + Hy(i,j-dy,k);
    cnt += 2;
}

if (cnt == 0.0)
    Hy(i,j,k) = Hy0;
else
    Hy(i,j,k) = p(1) * Hy0 + (1-p(1)) * (Hy1/cnt);

Hy(i,j,k) = p(1) * Hy0 + (1-p(1)) * (Hy1/cnt);
