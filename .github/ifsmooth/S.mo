model S
  Boolean on = sin(time) > 0;
  Real m(start = 1, fixed = true);
  Real d, x;
equation
  if on then
    d = 0;
    der(m) = 1;
    x = 0;
  else
    x = m^2;
    d = smooth(1, -x);
    der(m) = d;
  end if;
end S;
