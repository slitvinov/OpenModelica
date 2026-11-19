model I1 "cat of a Real matrix and identity(2): --newBackend checkSystemVariabilities Real != Integer"
  Real x(start = 1, fixed = true);
  Real A[2, 2] = {{x, 1}, {2, x}};
  Real E[2, 4] = cat(2, A, identity(2));
equation
  der(x) = -x;
end I1;
