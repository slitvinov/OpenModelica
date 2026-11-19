model D6 "same, only der(f(s))"
  function f
    input Real s;
    output Real y;
  algorithm
    y := 0;
    for i in 1:2 loop
      y := y + 0.5*s^2;
    end for;
    annotation(derivative = f_d, derivative(order = 2) = f_dd);
  end f;
  function f_d
    input Real s;
    input Real ds;
    output Real y;
  algorithm
    y := 2*s*ds;
  end f_d;
  function f_dd
    input Real s;
    input Real ds;
    input Real dds;
    output Real y;
  algorithm
    y := 2*ds^2 + 2*s*dds;
  end f_dd;
  Real s(start = 1, fixed = true);
  Real u, v;
equation
  der(s) = -s;
  u = f(s);
  v = der(u);
end D6;
