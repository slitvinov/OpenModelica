model J
  function f
    input Real x;
    input Real m;
    output Real y;
  protected
    Real ma;
  algorithm
    ma := noEvent(abs(m));
    y := ma * x;
    annotation(Inline = false);
  end f;
  parameter Real m = -50;
  Real x(start = 1, fixed = true);
equation
  der(x) = -f(x, m);
end J;
