model A
  discrete Integer n(start = 0, fixed = true);
  discrete Real t0(start = -1, fixed = true);
algorithm
  when initial() then
    t0 := time;
  elsewhen time > 0.5 then
    n := pre(n) + 1;
  end when;
end A;
