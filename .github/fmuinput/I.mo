package I
  model WithInput
    parameter Integer n = 20000;
    input Real u(start = 1);
    Real x[n](each start = 1, each fixed = true);
  equation
    der(x) = -x .+ u;
  end WithInput;
  model NoInput
    parameter Integer n = 20000;
    parameter Real u = 1;
    Real x[n](each start = 1, each fixed = true);
  equation
    der(x) = -x .+ u;
  end NoInput;
end I;
