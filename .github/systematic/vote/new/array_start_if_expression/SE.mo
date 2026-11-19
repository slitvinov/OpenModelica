model SE "same, start = cat(...) only"
  parameter Boolean sa = true;
  parameter Real r[4] = {1, 2, 3, 4};
  Real T[3](start = cat(1, {10}, {10 + sum(r[k] for k in 1:i - 1) for i in 2:3}));
equation
  der(T) = -T;
end SE;
