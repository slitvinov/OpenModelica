model HeatNet "6-node heat network: conduction ring, radiation chords, convection; exact temperatures Te(time)"
  // T = zT/s (group A, typical 300 K), heat flows Q = zQ/sb (group B, typical 300 W); se: equation scale;
  // nf: nominal factor (0: no nominal). Start values are scaled with the unknowns.
  parameter Real s = 1, sb = 1, se = 1, nf = 0;
  constant Integer N = 6;
  parameter Real G = 10 "ring conductance W/K";
  parameter Real c = 2*5.67e-8 "radiation coefficient W/K4";
  parameter Real h = 3 "convection W/K";
  parameter Real Ta = 280;
  Real zT[N](each start = 300*s, each nominal = if nf > 0 then nf*300*s else 1);
  Real zQ[N](each start = 0, each nominal = if nf > 0 then nf*300*sb else 1) "ring flow i -> i+1";
  Real zR[3](each start = 0, each nominal = if nf > 0 then nf*300*sb else 1) "radiation i -> i+3";
  Real err;
protected
  Real Te[N] = {300 + 15*sin(i) + 10*sin(6.283185307179586*time + i) for i in 1:N};
  Real P[N] "source, from the exact solution";
equation
  for i in 1:N loop
    P[i] = G*(Te[i] - Te[mod(i, N) + 1]) - G*(Te[mod(i - 2, N) + 1] - Te[i]) + h*(Te[i] - Ta)
      + (if i <= 3 then c*(Te[i]^4 - Te[i + 3]^4) else -c*(Te[i - 3]^4 - Te[i]^4));
    se*(zQ[i]/sb) = se*(G*(zT[i]/s - zT[mod(i, N) + 1]/s));
    se*(P[i] - zQ[i]/sb + zQ[mod(i - 2, N) + 1]/sb - h*(zT[i]/s - Ta)
      - (if i <= 3 then zR[i]/sb else -zR[i - 3]/sb)) = 0;
  end for;
  for j in 1:3 loop
    se*(zR[j]/sb) = se*(c*((zT[j]/s)^4 - (zT[j + 3]/s)^4));
  end for;
  err = max(abs(zT/s - Te) ./ Te);
end HeatNet;
