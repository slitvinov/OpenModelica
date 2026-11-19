model A
  Integer n(start = 0, fixed = true);
algorithm
  when not initial() then
    n := 1;
  end when;
end A;
