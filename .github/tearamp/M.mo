model M
  parameter Integer N;
  Real T[N+1];
equation
  T[1] = 2;
  for i in 2:N loop
    T[i-1] - 12*T[i] + T[i+1] = -10;
  end for;
  T[N] = T[N+1]^3;
end M;
