model RB
  function fpoly
    input Real x;
    input Real c[:];
    output Real y;
  algorithm
    y := 0;
    for i in size(c, 1) : - 1 : 1 loop
      y := y * x + c[i];
    end for;
  end fpoly;
  Real x1;
  Real u1;
equation
  der(x1) = u1;
  x1 = fpoly(time, {0.939, 0.06, 0.005});
end RB;
