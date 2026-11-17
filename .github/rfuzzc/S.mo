model S
  function f
    input Real u;
    output Real y;
  algorithm
    y := if u < 1 then u else f(u - 1);
  end f;
  Real x(start = 0, fixed = true);
equation
  der(x) = -x + f(time);
end S;
