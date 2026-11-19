model A
  type E = enumeration(a, b);
  E e = if time > 0.5 then E.b else E.a;
  Real x(start = 1, fixed = true);
equation
  der(x) = Integer(e) - x;
end A;
