model Zfluid2051
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial);
  Modelica.Fluid.Valves.ValveLinear valve1(redeclare package Medium=Modelica.Media.Water.ConstantPropertyLiquidWater, dp_nominal=3.522e+04, m_flow_nominal=0.3666);
  Modelica.Blocks.Sources.CombiTimeTable src1(table=[0, 0.7054; 31.92, 0.7498; 35.03, 0.9777; 38.8, 0.8396; 45.67, 0.6103], smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments, extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic);
  Modelica.Fluid.Sources.Boundary_pT bou1(redeclare package Medium=Modelica.Media.Water.ConstantPropertyLiquidWater, p=1.124e+05, T=284.6, nPorts=1);
  Modelica.Fluid.Vessels.ClosedVolume vol1(redeclare package Medium=Modelica.Media.Water.ConstantPropertyLiquidWater, V=0.02472, nPorts=1, use_portsData=false, T_start=328.8, p_start=1e+05, use_HeatTransfer=false);
equation
  connect(src1.y[1], valve1.opening);
  connect(vol1.ports[1], valve1.port_b);
  connect(bou1.ports[1], valve1.port_a);
  annotation(experiment(StartTime=0, StopTime=63.4, Interval=0.317));
end Zfluid2051;
