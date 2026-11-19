model A
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient amb1(constantAmbientPressure = 1e5, constantAmbientTemperature = 303.15);
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient amb2(constantAmbientPressure = 1e5, constantAmbientTemperature = 303.15);
  Modelica.Thermal.FluidHeatFlow.Sources.VolumeFlow pump(m = 0.1, T0 = 303.15, constantVolumeFlow = 1e-3);
equation
  connect(amb1.flowPort, pump.flowPort_a);
  connect(pump.flowPort_b, amb2.flowPort);
end A;
