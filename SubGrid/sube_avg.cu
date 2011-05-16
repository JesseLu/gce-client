if ((A < aneg) | (A > apos) | (B < bneg) | (B > bpos)) {
    float sube_temp = sube(i+sx,j+sy,k+sz);
    float E_temp = E(i,j,k);

    sube(i+sx,j+sy,k+sz) =  p(0) * sube(i+sx,j+sy,k+sz) + (1-p(0)) * E_temp;
    E(i,j,k) = p(0) * E(i,j,k) + (1-p(0)) * sube_temp;
}


