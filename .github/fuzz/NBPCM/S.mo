model S
  parameter Real R[3](each fixed = false);
  Real T[3](start = {sum(R[1:i]) for i in 1:3});
initial equation
  R = {1, 2, 3};
equation
  der(T) = -T;
end S;
