model C
  Modelica.Mechanics.Rotational.Components.Inertia J1(J = 1, phi(fixed = true, start = 0), w(fixed = true, start = 10));
  Modelica.Mechanics.Rotational.Components.Inertia J2(J = 1, phi(fixed = true, start = 0), w(fixed = true, start = 0));
  Modelica.Mechanics.Rotational.Components.Clutch clutch(fn_max = 20);
  Modelica.Blocks.Sources.Constant c(k = 1);
equation
  connect(J1.flange_b, clutch.flange_a);
  connect(clutch.flange_b, J2.flange_a);
  connect(c.y, clutch.f_normalized);
end C;
