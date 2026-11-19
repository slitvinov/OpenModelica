package V
model NI0
  Integer n(start = 0, fixed = true);
equation
  when not initial() then
    n = pre(n) + 1;
  end when;
end NI0;
model NI1
  Integer n(start = 0, fixed = true);
equation
  when not initial() then
    n = 1;
  end when;
end NI1;
model NI2
  Integer n(start = 0, fixed = true);
algorithm
  when not initial() then
    n := 1;
  end when;
end NI2;
model NI3
  Integer n(start = 0, fixed = true);
  Boolean c = not initial();
equation
  when c then
    n = 1;
  end when;
end NI3;
model NI4
  Integer n(start = 0, fixed = true);
equation
  when time > 0 then
    n = 1;
  end when;
end NI4;
model NI5
  Real n(start = 0, fixed = true);
equation
  when not initial() then
    n = 1;
  end when;
end NI5;
model C1
  Real x(start = 0, fixed = true);
  Integer n(start = 0, fixed = true);
  Integer e(start = 0, fixed = true);
equation
  der(x) = 1;
algorithm
  when x > 0.3 then
    n := 1;
  end when;
  when change(n) then
    e := 1;
  end when;
end C1;
model C2
  Real x(start = 0, fixed = true);
  Integer n(start = 0, fixed = true);
  Integer e(start = 0, fixed = true);
  Boolean b = x > 0.3;
equation
  der(x) = 1;
algorithm
  when edge(b) then
    n := 1;
  end when;
  when change(n) then
    e := 1;
  end when;
end C2;
model C3
  Real x(start = 0, fixed = true);
  Integer n(start = 0, fixed = true);
  Integer e(start = 0, fixed = true);
equation
  der(x) = 1;
algorithm
  when x > 0.3 then
    n := 1;
  end when;
algorithm
  when change(n) then
    e := 1;
  end when;
end C3;
model C4
  Real x(start = 0, fixed = true);
  Integer n(start = 0, fixed = true);
  Integer e(start = 0, fixed = true);
equation
  der(x) = 1;
  when x > 0.3 then
    n = 1;
  end when;
  when change(n) then
    e = 1;
  end when;
end C4;
model C5
  Real x(start = 0, fixed = true);
  Integer n(start = 0, fixed = true);
  Integer e(start = 0, fixed = true);
equation
  der(x) = 1;
algorithm
  when x > 0.3 then
    n := 1;
  end when;
  when x > 0.6 then
    e := 1;
  end when;
end C5;
model C6
  Integer n(start = 0, fixed = true);
  Integer e(start = 0, fixed = true);
algorithm
  when time > 0.3 then
    n := 1;
  end when;
  when change(n) then
    e := 1;
  end when;
end C6;
model C7
  Real x(start = 0, fixed = true);
  Integer n(start = 0, fixed = true);
  Integer e(start = 0, fixed = true);
equation
  der(x) = 1;
algorithm
  when x > 0.3 then
    n := 1;
  end when;
  when n > 0 then
    e := 1;
  end when;
end C7;
end V;
