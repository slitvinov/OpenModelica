model E6
  Boolean u = time > 2 and time < 4;
  Boolean d(start = false, fixed = true);
algorithm
  when u then
    d := true;
  end when;
  when not u then
    d := false;
  end when;
end E6;
