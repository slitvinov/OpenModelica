package P
  record R2
    Real a = 1;
  end R2;
  record R1
    R2 r2;
    Real b = 2;
  end R1;
  model C
    parameter R1 per(r2(a = 3));
    Real x;
  equation
    der(x) = -per.r2.a * x + per.b;
  end C;
  model M
    C c(per(b = 4));
  end M;
end P;
