model AT3 "MSL FluidHeatFlow Ambient alone"
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient amb1(medium = Modelica.Thermal.FluidHeatFlow.Media.MineralOil(), constantAmbientPressure = 9.082e+04, constantAmbientTemperature = 303.1);
  Modelica.Thermal.FluidHeatFlow.Sources.Ambient amb2(medium = Modelica.Thermal.FluidHeatFlow.Media.MineralOil(), constantAmbientPressure = 7.463e+04, constantAmbientTemperature = 303.1);
  Modelica.Thermal.FluidHeatFlow.Components.Valve valve1(medium = Modelica.Thermal.FluidHeatFlow.Media.MineralOil(), m = 0.1559, T0 = 303.1, LinearCharacteristic = true, y1 = 1, Kv1 = 2.167, kv0 = 0.07586, dp0 = 3981, rho0 = 1000);
  Modelica.Blocks.Sources.Constant src2(k = 0.7);
equation
  connect(src2.y, valve1.y);
  connect(amb1.flowPort, valve1.flowPort_a);
  connect(valve1.flowPort_b, amb2.flowPort);
end AT3;
