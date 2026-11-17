model N
  constant Integer k = 2;
  Real B[2, 2] = [1, time; 0, 2];
  Real q[2, 2] = B^k;
end N;
