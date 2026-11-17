model S
  Real x1(start = 0.5, fixed = true), y1(start = -0.866), x2(start = 1.0, fixed = true), y2(start = -1.732);
  Real vx1(start = 0, fixed = true), vy1(start = 0), vx2(start = 0, fixed = true), vy2(start = 0);
  Real l1, l2;
equation
  der(x1) = vx1;
  der(y1) = vy1;
  der(x2) = vx2;
  der(y2) = vy2;
  der(vx1) = -l1*x1 + l2*(x2 - x1);
  der(vy1) = -l1*y1 + l2*(y2 - y1) - 9.81;
  der(vx2) = -l2*(x2 - x1);
  der(vy2) = -l2*(y2 - y1) - 9.81;
  x1^2 + y1^2 = 1;
  (x2 - x1)^2 + (y2 - y1)^2 = 1;
end S;
