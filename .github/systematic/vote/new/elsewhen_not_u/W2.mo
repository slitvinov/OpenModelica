model W2 "same with a when equation"
  Boolean u = time > 2 and time < 4;
  Boolean d(start = false, fixed = true);
equation
  when u then
    d = true;
  elsewhen not u then
    d = false;
  end when;
end W2;
