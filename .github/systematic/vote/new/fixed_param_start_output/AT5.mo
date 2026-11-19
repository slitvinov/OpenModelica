model AT5
  parameter Real cp = 2010;
  parameter Real T0 = 293.15;
  parameter Boolean T0fixed = false;
  parameter Real Tc = 303.1;
  output Real T(start = T0);
  Real h;
  Real Ta;
  Real x(start = 0, fixed = true);
equation
  T = h/cp;
  Ta = Tc;
  T = Ta;
  der(x) = h/cp - x;
end AT5;
