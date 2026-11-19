model RoomRad "Room long-wave radiation as in Buildings (linearized T^4, radiosity): linear system with T ~ 300, T4 ~ 7e9, J ~ 400"
  // Group A (scale s): surface temperatures T and T4 = T^4 (linearized); group B (scale sb): radiosity J and
  // irradiation G; se: equation scale; nf: nominal factor (0: no nominal). Exact temperatures Te(time).
  parameter Real s = 1, sb = 1, se = 1, nf = 0;
  constant Integer N = 8;
  constant Real sigma = 5.670374419e-8;
  parameter Real T0 = 293.15 "linearization temperature";
  parameter Real Asur[N] = {12, 12, 9, 9, 10, 10, 2.4, 1.6};
  parameter Real eps[N] = {0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.84, 0.84};
  parameter Real F[N, N] = {{if i == j then 0 else Asur[j]/(sum(Asur) - Asur[i]) for j in 1:N} for i in 1:N};
  parameter Real hc[N] = {2, 2, 2.5, 2.5, 1.5, 3, 5, 5} "conduction to the back side W/m2K";
  parameter Real ha = 3 "convection W/m2K";
  parameter Real Tair = 295;
  Real zT[N](each start = T0*s, each nominal = if nf > 0 then nf*300*s else 1);
  Real zT4[N](each start = T0^4*s, each nominal = if nf > 0 then nf*7.4e9*s else 1);
  Real zJ[N](each start = 400*sb, each nominal = if nf > 0 then nf*420*sb else 1);
  Real zG[N](each start = 400*sb, each nominal = if nf > 0 then nf*420*sb else 1);
  Real err;
protected
  Real Te[N] = {290 + 3*i + 4*sin(6.283185307179586*time + i) for i in 1:N} "exact";
  Real T4e[N] = T0^3*(4*Te - 3*T0*ones(N));
  Real Je[N] = Modelica.Math.Matrices.solve(identity(N) - diagonal(ones(N) - eps)*F, eps*sigma .* T4e);
  Real Ge[N] = F*Je;
  Real Tb[N] = {285 + 2*i + 2*cos(6.283185307179586*time) for i in 1:N} "back-side temperatures";
  Real P[N] "source, from the exact solution";
equation
  P = hc .* (Tb - Te) + ha*(Tair*ones(N) - Te) + (Ge - Je);
  for i in 1:N loop
    se*(zT4[i]/s) = se*(T0^3*(4*zT[i]/s - 3*T0));
    se*(zJ[i]/sb) = se*(eps[i]*sigma*zT4[i]/s + (1 - eps[i])*zG[i]/sb);
    se*(zG[i]/sb) = se*(F[i, :]*zJ/sb);
    se*(hc[i]*(Tb[i] - zT[i]/s) + ha*(Tair - zT[i]/s) + (zG[i] - zJ[i])/sb) = se*P[i];
  end for;
  err = max(abs(zT/s - Te) ./ Te);
end RoomRad;
