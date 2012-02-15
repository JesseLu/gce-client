Ex(i,j,k) = p(0) * Ex(i+(jump),j,k) - p(1) * Dx(i+(jump),j,k);
Ey(i,j,k) = p(0) * Ey(i+(jump),j,k) - p(1) * Dy(i+(jump),j,k);
Ez(i,j,k) = p(0) * Ez(i+(jump),j,k) - p(1) * Dz(i+(jump),j,k);
Dx(i,j,k) = p(1) * Ex(i+(jump),j,k) + p(0) * Dx(i+(jump),j,k);
Dy(i,j,k) = p(1) * Ey(i+(jump),j,k) + p(0) * Dy(i+(jump),j,k);
Dz(i,j,k) = p(1) * Ez(i+(jump),j,k) + p(0) * Dz(i+(jump),j,k);
