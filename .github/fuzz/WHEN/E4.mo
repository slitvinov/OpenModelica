model E4
  Boolean u = time > 2 and time < 4;
  Boolean v = not u;
  Boolean d(start = false, fixed = true);
algorithm
  when u then
    d := true;
  elsewhen v then
    d := false;
  end when;
end E4;
