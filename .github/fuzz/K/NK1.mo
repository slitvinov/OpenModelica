model NK1
  Real s;
algorithm
  s := 0;
  for i in 1:2 loop
    s := s + mod(time + i, 0.4);
  end for;
end NK1;
