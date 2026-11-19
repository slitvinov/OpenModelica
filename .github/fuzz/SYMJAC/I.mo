model I
  type E = enumeration(a, b);
  E e = E.b;
  Real x;
equation
  der(x) = Integer(e);
end I;
