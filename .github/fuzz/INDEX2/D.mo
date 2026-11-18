model D
  function f
    input Real x;
    output Real y;
  algorithm
    y := 1;
    for i in 1:1 loop
      y := y*x;
    end for;
  end f;
  Real x = f(time);
  Real u = der(x);
end D;
