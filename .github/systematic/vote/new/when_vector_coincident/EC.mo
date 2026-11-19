model EC "vector when: sample tick and a time relation crossing at the same instant t = 1"
  Integer n(start = 0, fixed = true);
equation
  when {sample(0, 0.5), time > 1.0} then
    n = pre(n) + 1;
  end when;
end EC;
