model D4
  block Mean
    input Real u;
    output Real y;
    parameter Real f = 50;
    parameter Real y0 = 0.5;
  protected
    parameter Real t0(fixed = false);
    Real x;
    discrete Real y_last;
  initial equation
    t0 = time;
    x = 0;
    y_last = y0;
  equation
    der(x) = u;
    when sample(t0 + 1/f, 1/f) then
      y_last = f*pre(x);
      reinit(x, 0);
    end when;
    y = y_last;
  end Mean;
  Mean mean(u = 1);
end D4;
