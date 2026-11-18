package P
model SQ6 "original report"
  Real x1;
  Real x2(start = 1, fixed = true);
equation
  der(x2) = 1;
  x2 = if x1 > 0 then x1 + 0.3*x1^2 else x1 - 0.3*x1^2;
end SQ6;
model SQ6smooth "casella's suggestion: smooth(0, ...)"
  Real x1;
  Real x2(start = 1, fixed = true);
equation
  der(x2) = 1;
  x2 = smooth(0, if x1 > 0 then x1 + 0.3*x1^2 else x1 - 0.3*x1^2);
end SQ6smooth;
model SQ6noEvent "noEvent"
  Real x1;
  Real x2(start = 1, fixed = true);
equation
  der(x2) = 1;
  x2 = noEvent(if x1 > 0 then x1 + 0.3*x1^2 else x1 - 0.3*x1^2);
end SQ6noEvent;
model SQ6disc "discontinuous on purpose (jump of 0.1 at x1 = 0), x1 still unique"
  Real x1;
  Real x2(start = 1, fixed = true);
equation
  der(x2) = 1;
  x2 = if x1 > 0 then x1 + 0.3*x1^2 + 0.1 else x1 - 0.3*x1^2;
end SQ6disc;
model SQ6then "only the active branch"
  Real x1;
  Real x2(start = 1, fixed = true);
equation
  der(x2) = 1;
  x2 = x1 + 0.3*x1^2;
end SQ6then;
end P;
