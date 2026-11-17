model S
  record R
    Real 'a';
  end R;
  function f
    input Real x;
    output R r;
  algorithm
    r.'a' := x;
  end f;
  R q = f(time);
end S;
