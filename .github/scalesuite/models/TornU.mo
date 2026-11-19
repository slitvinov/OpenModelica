model TornU "#18250 U: 5 coupled nonlinear equations, torn by the old backend; exact solution xe(time)"
  // x = z/scale. s: scale of z1..z3 (group A); sb: scale of z4, z5 (group B); se: equation scale;
  // nf: nominal factor (0: no nominal); st: start = st*xe(0)*scale (scaled with the unknowns).
  parameter Real s = 1, sb = 1, se = 1, nf = 0, st = 0.9;
  parameter Real x0[5] = {-0.6, -0.7, 0.1, 0.7, 0.1};
  Real z1(start = st*x0[1]*s, nominal = if nf > 0 then nf*s*0.6 else 1);
  Real z2(start = st*x0[2]*s, nominal = if nf > 0 then nf*s*0.7 else 1);
  Real z3(start = st*x0[3]*s, nominal = if nf > 0 then nf*s*0.1 else 1);
  Real z4(start = st*x0[4]*sb, nominal = if nf > 0 then nf*sb*0.7 else 1);
  Real z5(start = st*x0[5]*sb, nominal = if nf > 0 then nf*sb*0.1 else 1);
  Real err;
protected
  Real e[5] = x0*(1 + 0.5*time) "exact solution";
equation
  se*(1.2*z1/s - 0.5*z5/sb + 0.6*sinh(z1/s)) = se*(1.2*e[1] - 0.5*e[5] + 0.6*sinh(e[1]));
  se*(0.7*z2/s - 0.2*z3/s + 0.3*sinh(z2/s)) = se*(0.7*e[2] - 0.2*e[3] + 0.3*sinh(e[2]));
  se*(0.2*z2/s + 1.5*z3/s + 0.3*(z3/s)^5 + 0.4*z4/sb) = se*(0.2*e[2] + 1.5*e[3] + 0.3*e[3]^5 + 0.4*e[4]);
  se*(-0.4*z3/s + 1.7*z4/sb + z5/sb + 0.3*exp(z4/sb)) = se*(-0.4*e[3] + 1.7*e[4] + e[5] + 0.3*exp(e[4]));
  se*(0.5*z1/s - z4/sb + 1.2*z5/sb + 0.3*(z5/sb)^5) = se*(0.5*e[1] - e[4] + 1.2*e[5] + 0.3*e[5]^5);
  err = max(abs({z1/s, z2/s, z3/s, z4/sb, z5/sb} - e) ./ {max(abs(e[i]), 0.1) for i in 1:5});
end TornU;
