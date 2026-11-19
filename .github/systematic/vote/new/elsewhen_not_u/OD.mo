model OD
  Boolean u = time > 2 and time < 4;
  Boolean y;
  parameter Real delayTime = 1;
protected
  Boolean delaySignal(start = false, fixed = true);
  discrete Real t_next;
initial equation
  pre(u) = false;
  pre(t_next) = time - 1;
algorithm
  when initial() then
    delaySignal := u;
    t_next := time - 1;
  elsewhen u then
    delaySignal := true;
    t_next := time + delayTime;
  elsewhen not u then
    delaySignal := false;
    t_next := time - 1;
  end when;
equation
  if delaySignal then
    y = time >= t_next;
  else
    y = false;
  end if;
  annotation(experiment(StopTime = 6));
end OD;
