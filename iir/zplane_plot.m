[b,a]=butter(2, 0.3, 'high'); figure; freqz(b,a); figure; zplane(b,a);