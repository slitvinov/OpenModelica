model B
  Boolean b(start = false, fixed = true);
equation
  b = (pre(b) or initial()) and time < 0.7;
end B;
