model RE1
  record Rk
    Real a;
    Real b;
  end Rk;
  function f
    input Real x;
    output Rk r;
  algorithm
    r.a := x + 0.2*sin(x);
    r.b := cos(x);
  end f;
  parameter Real p = 0.8;
  Real x2;
  Real x3;
  Real u;
  Rk r = f(x3);
equation
  der(x2) = 1;
  der(x3) = x2 + u;
  p = r.a;
end RE1;
