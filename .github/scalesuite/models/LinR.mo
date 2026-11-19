model LinR "#18082: 3x3 dense linear system; exact solution y0*(1 + time)"
  // Unknowns z = scale*y. s: scale of z1, z2 (group A); sb: scale of z3 (group B);
  // se: equation scale; nf: nominal factor (0: no nominal, else nominal = nf*|typical|*scale).
  parameter Real s = 1, sb = 1, se = 1, nf = 0;
  parameter Real A[3, 3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 10}};
  parameter Real b0[3] = {1/3, 2/7, 5/11};
  parameter Real y0[3] = Modelica.Math.Matrices.solve(A, b0);
  Real z1(nominal = if nf > 0 then nf*s*abs(y0[1]) else 1);
  Real z2(nominal = if nf > 0 then nf*s*abs(y0[2]) else 1);
  Real z3(nominal = if nf > 0 then nf*sb*abs(y0[3]) else 1);
  Real err "max relative error vs the exact solution";
equation
  se*(A*{z1/s, z2/s, z3/sb}) = se*b0*(1 + time);
  err = max(abs({z1/s, z2/s, z3/sb} - y0*(1 + time)) ./ abs(y0*(1 + time)));
end LinR;
