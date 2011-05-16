float Hz0 = Hz(i,j,k) - \
    p(0) * ((Ey(i+dz,j,k)-Ey(i,j,k)) - (Ex(i,j+dy,k)-Ex(i,j,k)));

float Hz1 = 0;
float cnt = 0;

if ((i < ineg) | ( i > ipos)) {
    Hz1 += Hz(i-dx,j,k) + Hz(i+dx,j,k);
    cnt += 2;
}
if ((j < jneg) | ( j > jpos)) {
    Hz1 += Hz(i,j-dy,k) + Hz(i,j-dy,k);
    cnt += 2;
}

Hz(i,j,k) = p(1) * Hz0 + (1-p(1)) * (Hz1/cnt);
