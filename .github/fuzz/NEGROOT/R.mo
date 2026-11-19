model R
  type Temperature = Real(unit = "K", min = 0);
  parameter Real TA = 288;
  Temperature T1(start = 293);
  Temperature T2(start = 320);
  Real Q1, Q2, Q3;
initial equation
  der(T1) = 0;
  der(T2) = 0;
equation
  Q1 = 25*(T1 - TA);
  Q2 = 6e-8*(T2^4 - T1^4);
  Q3 = 0.1*(TA - T2);
  der(T1) = Q2 - Q1;
  der(T2) = Q3 - Q2;
end R;
