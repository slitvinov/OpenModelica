model RP "two resistors in parallel between ground and an otherwise unconnected node (+ an independent RC)"
  Modelica.Electrical.Analog.Basic.Ground g;
  Modelica.Electrical.Analog.Basic.Resistor R2(R = 4);
  Modelica.Electrical.Analog.Basic.Resistor R3(R = 100.4);
  Real x(start = 1, fixed = true);
equation
  connect(g.p, R2.n);
  connect(R2.n, R3.n);
  connect(R2.p, R3.p);
  der(x) = -x;
end RP;
