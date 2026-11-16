model RW4
  Boolean b = time > 0.5;
  Real x1(start = 1, fixed = true);
  Real x2(start = 0, fixed = true);
equation
  der(x1) = 1;
  der(x2) = 0;
  when b then
    reinit(x1, 10);
  end when;
  when b then
    reinit(x2, x1);
  end when;
end RW4;
