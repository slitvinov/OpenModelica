package M1498_P
  function gc
    input Real x1;
    input Real x2;
    input Real x3;
    output Real g;
  algorithm
    g := 0.204*(x2)^(2) - 0.761*sin(x3) - 0.564*sinh(x1);
  annotation(derivative=gc_d);
  end gc;
  function gc_d
    input Real x1;
    input Real x2;
    input Real x3;
    input Real dx1;
    input Real dx2;
    input Real dx3;
    output Real dg;
  algorithm
    dg := -0.564*dx1*cosh(x1) + 0.408*dx2*x2 - 0.761*dx3*cos(x3);
  end gc_d;
model M1498
  Real x1(start=-0.62);
  Real x2(start=-0.904, fixed=true);
  Real x3(start=-0.09519538845632572, fixed=true);
  Real y(start=0.044);
equation
  der(x1) = -0.703*x1 + y + (0.127474*(time)^(2) + 0.362404*time - 0.71086 + 0.499/(1.242*(time)^(2) + 1));
  der(x2) = -0.284*x1 - 1.51*x2 - 0.156*sin(x2) + (-0.011928*(time)^(2) + 0.076112*time + 0.464332*time/(0.346*(time)^(2) + 1)^(2) - 0.156*sin(0.233 + 0.671/(0.346*(time)^(2) + 1)) - 0.52791 - 1.01321/(0.346*(time)^(2) + 1));
  der(x3) = -0.791*x2 - 0.722*x3 - 0.078*sin(x2) + (-0.078*sin(0.233 + 0.671/(0.346*(time)^(2) + 1)) + 0.188442*sin(0.951*time + 0.71) + 0.30685*sin(3.601*time + 2.137) + 0.248211*cos(0.951*time + 0.71) + 1.530425*cos(3.601*time + 2.137) - 0.634831 - 0.530761/(0.346*(time)^(2) + 1));
  gc(x1, x2, x3) = 0.091849164*(-0.3472429210134128 - 1/(0.346*(time)^(2) + 1))^(2) - 0.761*sin(0.261*sin(0.951*time + 0.71) + 0.425*sin(3.601*time + 2.137) - 0.624) + 0.564*sinh(0.042*(time)^(2) - 0.268*time + 0.62);
end M1498;
end M1498_P;
