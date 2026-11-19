model RB "bouncing ball: when h < 0 then reinit(v, ..pre(v)..) elsewhen sample() then reinit(v, pre(v) + 1.6)"
  Real h(start = 0.7, fixed = true);
  Real v(start = 0, fixed = true);
  Integer c(start = 0, fixed = true);
equation
  der(h) = v;
  der(v) = -9.81;
  when h < 0 then
    reinit(v, max(-0.76*pre(v), 1.0));
    c = pre(c) + 1;
  elsewhen sample(0.4, 0.5) then
    reinit(v, pre(v) + 1.6);
    c = pre(c) + 10;
  end when;
end RB;
