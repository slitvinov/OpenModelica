model E
  Integer n(start = 0, fixed = true);
equation
  when not initial() then
    n = 1;
  end when;
end E;
