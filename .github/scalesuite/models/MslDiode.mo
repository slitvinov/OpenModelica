model MslDiode "MSL diode circuit, R*s and Ids/s: currents scale 1/s, voltages unchanged (nonlinear system)"
  // nf: nominal factor on the currents (0: no nominal): nominal = nf*1e-3/s.
  import Modelica.Electrical.Analog.Basic;
  parameter Real s = 1, nf = 0;
  parameter Real R1v = 100, R2v = 1000, Ids = 1e-6, Rd = 1e8, Vt = 0.025, Maxexp = 15;
  parameter Real inom = if nf > 0 then nf*1e-3/s else 1;
  Basic.Ground gnd;
  Modelica.Electrical.Analog.Sources.SignalVoltage V;
  Basic.Resistor R1(R = R1v*s, i(nominal = inom));
  Basic.Resistor R2(R = R2v*s, i(nominal = inom));
  Modelica.Electrical.Analog.Semiconductors.Diode D(Ids = Ids/s, R = Rd*s, Vt = Vt, Maxexp = Maxexp, i(nominal = inom));
  Real err;
  function vexact "node voltage at unit scale, bisection"
    input Real V, R1v, R2v, Ids, Rd, Vt, Maxexp;
    output Real v;
  protected
    Real a = 0, b = V, f;
  algorithm
    for it in 1:200 loop
      v := (a + b)/2;
      f := (V - v)/R1v - v/R2v - (if v/Vt > Maxexp then Ids*(exp(Maxexp)*(1 + v/Vt - Maxexp) - 1) + v/Rd
        else Ids*(exp(v/Vt) - 1) + v/Rd);
      if f > 0 then a := v; else b := v; end if;
    end for;
  end vexact;
protected
  Real ve = vexact(V.v, R1v, R2v, Ids, Rd, Vt, Maxexp);
equation
  V.v = 0.5 + time;
  connect(V.p, R1.p); connect(R1.n, D.p); connect(R1.n, R2.p);
  connect(D.n, gnd.p); connect(R2.n, gnd.p); connect(V.n, gnd.p);
  err = max(abs(D.v - ve)/abs(ve), abs(R1.i*s - (V.v - ve)/R1v)/abs((V.v - ve)/R1v));
end MslDiode;
