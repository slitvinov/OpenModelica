model Zelec2092
  Modelica.Electrical.Analog.Basic.Ground gnd1;
  Modelica.Electrical.Analog.Sources.PulseVoltage V1(V=13.97, width=67.96, period=0.005569);
  Modelica.Electrical.Analog.Basic.Resistor R1(R=49.14);
  Modelica.Electrical.Analog.Basic.Resistor R2(R=4);
  Modelica.Electrical.Analog.Sources.ExpSineVoltage V2(V=6.631, f=77.26, damping=38.52);
  Modelica.Electrical.Analog.Basic.Resistor R3(R=100.4);
  Modelica.Electrical.Analog.Semiconductors.ZDiode ZD1(Bv=5.142, R=1.546e+07);
  Modelica.Electrical.Analog.Sensors.PotentialSensor PS1;
equation
  connect(gnd1.p, V1.n);
  connect(V1.n, R1.n);
  connect(R1.n, R2.n);
  connect(R2.n, R3.n);
  connect(V1.p, V2.p);
  connect(V2.p, ZD1.p);
  connect(R1.p, V2.n);
  connect(V2.n, ZD1.n);
  connect(R2.p, R3.p);
  connect(R3.p, PS1.p);
  annotation(experiment(StartTime=0, StopTime=0.0211, Interval=0.0001055));
end Zelec2092;
