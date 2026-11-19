model D11
  Real x(start = 0, fixed = true);
  discrete Real y_last;
  Real y;
initial equation
  y_last = 0.5;
equation
  der(x) = 1;
  when sample(0.02, 0.02) then
    y_last = pre(x);
  end when;
  y = y_last;
end D11;
