model MslBridge "MSL Wheatstone bridge, all resistances R*s: currents scale 1/s, voltages unchanged"
  // nf: nominal factor on the resistor currents (0: no nominal): nominal = nf*0.01/s.
  import Modelica.Electrical.Analog.Basic;
  parameter Real s = 1, nf = 0;
  parameter Real R[5] = {100, 220, 150, 390, 470};
  parameter Real inom = if nf > 0 then nf*0.01/s else 1;
  Basic.Ground gnd;
  Modelica.Electrical.Analog.Sources.SignalVoltage V;
  Basic.Resistor R1(R = R[1]*s, i(nominal = inom));
  Basic.Resistor R2(R = R[2]*s, i(nominal = inom));
  Basic.Resistor R3(R = R[3]*s, i(nominal = inom));
  Basic.Resistor R4(R = R[4]*s, i(nominal = inom));
  Basic.Resistor R5(R = R[5]*s, i(nominal = inom));
  Real err;
protected
  Real ve[2] = Modelica.Math.Matrices.solve({{1/R[1] + 1/R[2] + 1/R[5], -1/R[5]}, {-1/R[5], 1/R[3] + 1/R[4] + 1/R[5]}},
    {1/R[1], 1/R[3]}*V.v) "exact node voltages (unit scale)";
equation
  V.v = 10*(1 + time);
  connect(V.p, R1.p); connect(V.p, R3.p);
  connect(R1.n, R2.p); connect(R3.n, R4.p);
  connect(R1.n, R5.p); connect(R3.n, R5.n);
  connect(R2.n, gnd.p); connect(R4.n, gnd.p); connect(V.n, gnd.p);
  err = max({abs(R2.v - ve[1])/abs(ve[1]), abs(R4.v - ve[2])/abs(ve[2]),
    abs(R5.i*s - (ve[1] - ve[2])/R[5])/abs((ve[1] - ve[2])/R[5]), abs(R1.i*s - (V.v - ve[1])/R[1])/abs((V.v - ve[1])/R[1])});
end MslBridge;
