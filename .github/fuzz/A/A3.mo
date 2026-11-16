model A3
  function f
    input Real x;
    input Integer n;
    output Real y;
  algorithm
    y := sum(i*x for i in 1:n);
    annotation(Inline = false);
  end f;
  Real x = f(time, 2);
  Real z = der(x);
end A3;
