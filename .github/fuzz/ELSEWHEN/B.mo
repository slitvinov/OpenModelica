model B
  discrete Integer n(start = 0, fixed = true);
  discrete Real t0(start = -1, fixed = true);
algorithm
  when time > 0.5 then
    n := pre(n) + 1;
  elsewhen initial() then
    t0 := time;
  end when;
end B;
