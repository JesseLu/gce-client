// The format for p (the parameters) is [omega, phase_delay, alpha, delay].
Ey(i,j,k) += source(i,j,k) * sinf(p[0] * t + p[1]) * 
    expf(-p[2] * powf(t - p[3], 2.0));
