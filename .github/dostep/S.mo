package S
  model In1
    input Real u;
    discrete Real d[1];
    Real x(start = 1, fixed = true);
  equation
    der(x) = -x + u;
    when initial() then
      d = fill(1.0, 1);
    end when;
  end In1;
  model No1
    Real u = 0;
    discrete Real d[1];
    Real x(start = 1, fixed = true);
  equation
    der(x) = -x + u;
    when initial() then
      d = fill(1.0, 1);
    end when;
  end No1;
  model In10000
    input Real u;
    discrete Real d[10000];
    Real x(start = 1, fixed = true);
  equation
    der(x) = -x + u;
    when initial() then
      d = fill(1.0, 10000);
    end when;
  end In10000;
  model No10000
    Real u = 0;
    discrete Real d[10000];
    Real x(start = 1, fixed = true);
  equation
    der(x) = -x + u;
    when initial() then
      d = fill(1.0, 10000);
    end when;
  end No10000;
  model In50000
    input Real u;
    discrete Real d[50000];
    Real x(start = 1, fixed = true);
  equation
    der(x) = -x + u;
    when initial() then
      d = fill(1.0, 50000);
    end when;
  end In50000;
  model No50000
    Real u = 0;
    discrete Real d[50000];
    Real x(start = 1, fixed = true);
  equation
    der(x) = -x + u;
    when initial() then
      d = fill(1.0, 50000);
    end when;
  end No50000;
end S;
