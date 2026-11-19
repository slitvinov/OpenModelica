model I
  type E = enumeration(a, b);
  E e = E.b;
  Real x(start = 0, fixed = true);
equation
  der(x) = Integer(e);
end I;
