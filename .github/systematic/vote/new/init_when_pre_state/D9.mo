model D9
  Real x(start = 0, fixed = true);
  discrete Real y_last(start = 0.5, fixed = true);
  Real y;
equation
  der(x) = 1;
  when sample(0.02, 0.02) then
    y_last = pre(x);
  end when;
  y = y_last;
end D9;
