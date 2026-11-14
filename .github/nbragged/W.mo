package W
  model Layer
    parameter Integer n;
    Real T[n](each start = 1, each fixed = true);
  equation
    der(T) = -T;
  end Layer;
  model R1
    Layer lay[2](n = {2, 3});
  end R1;
end W;
