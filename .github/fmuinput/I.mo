package I
  model WithInput
    parameter Integer n = 20000;
    input Real u(start = 1);
    Real x(start = 1, fixed = true);
    discrete Real z[n](each start = 0, each fixed = true);
  equation
    der(x) = -x + u;
    when x > 2 then
      z = fill(1, n);
    end when;
  end WithInput;
  model NoInput
    parameter Integer n = 20000;
    parameter Real u = 1;
    Real x(start = 1, fixed = true);
    discrete Real z[n](each start = 0, each fixed = true);
  equation
    der(x) = -x + u;
    when x > 2 then
      z = fill(1, n);
    end when;
  end NoInput;
end I;
