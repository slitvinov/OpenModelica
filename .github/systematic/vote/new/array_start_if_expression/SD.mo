model SD "array start given by an if-expression of array comprehensions (Buildings SingleLayer T start)"
  parameter Boolean sa = true;
  parameter Real r[4] = {1, 2, 3, 4};
  Real T[3](start = if sa then cat(1, {10}, {10 + sum(r[k] for k in 1:i - 1) for i in 2:3}) else {10 + sum(r[k] for k in 1:i) for i in 1:3});
equation
  der(T) = -T;
end SD;
