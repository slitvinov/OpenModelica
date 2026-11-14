model E
  record R
    parameter Integer n;
  end R;
  model M
    parameter R r[2];
    Real x[sum({r[i].n for i in 1:2})];
  end M;
  parameter R a[3] = {R(n = 1), R(n = 2), R(n = 3)};
  M m(r = {a[i] for i in 2:3});
end E;
