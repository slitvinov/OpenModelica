model N
  type Temperature = Real(unit = "K", min = 0, start = 288.15);
  Real q0;
  Temperature t1;
  Temperature t2;
  Temperature t3;
  Real q1;
  Temperature ta;
  Real qr;
  Real dt(start = 0);
  Real qc;
  Real q12;
  parameter Real alpha = 0;
  Real q2;
initial equation
  der(t1) = 0;
  der(t2) = 0;
  der(t3) = 0;
equation
  -q1 - 2.408*(t1 - 298.9) + q0 = 0;
  q12 - qc + qr + 2.408*(t1 - 298.9) + der(t1) = 0;
  q2 - q12 + q1 + der(t2) = 0;
  -49.26*(ta - t3) + qc + der(t3) = 0;
  -50 + 49.26*(ta - t3) + 0.4562*5.6703744191844314e-8*(ta^4 - t1^4) = 0;
  3.626*q1 = t2 - 298.9;
  qr = -0.4562*5.6703744191844314e-8*(ta^4 - t1^4);
  dt = t3 - t1;
  qc = 4.243*homotopy(noEvent(if dt > 0 then 1.3*dt^1.3333 else -1.3*(-dt)^1.3333), 1.638*dt);
  6.903*q12 = t1 - t2;
  q2 = -126.1*(1 + alpha*(t2 - 311.3));
end N;
