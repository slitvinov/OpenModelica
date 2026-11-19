model E
  Real x = time;
equation
  assert(x < 0.6, "Error: x > 0.6");
  assert(x < 0.3, "Warning: x > 0.3", AssertionLevel.warning);
end E;
