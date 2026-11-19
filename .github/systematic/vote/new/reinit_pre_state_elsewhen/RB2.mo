model RB2 "same with v instead of pre(v) in reinit"
  Real h(start = 0.7, fixed = true);
  Real v(start = 0, fixed = true);
  Integer c(start = 0, fixed = true);
equation
  der(h) = v;
  der(v) = -9.81;
  when h < 0 then
    reinit(v, max(-0.76*v, 1.0));
    c = pre(c) + 1;
  elsewhen sample(0.4, 0.5) then
    reinit(v, v + 1.6);
    c = pre(c) + 10;
  end when;
end RB2;
