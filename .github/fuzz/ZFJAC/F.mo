model F
  package Medium = Buildings.Media.Air;
  Buildings.Fluid.Sources.Boundary_pT sou(redeclare package Medium = Medium, p = 101825, nPorts = 1);
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium, p = 101325, nPorts = 1);
  Buildings.Fluid.FixedResistances.PressureDrop dpIn(redeclare package Medium = Medium, m_flow_nominal = 1, dp_nominal = 250);
  Buildings.Fluid.MixingVolumes.MixingVolume vol(redeclare package Medium = Medium, m_flow_nominal = 1, V = 0.1, nPorts = 2,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, massDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial);
  Buildings.Fluid.FixedResistances.PressureDrop dpOut(redeclare package Medium = Medium, m_flow_nominal = 1, dp_nominal = 250);
equation
  connect(sou.ports[1], dpIn.port_a);
  connect(dpIn.port_b, vol.ports[1]);
  connect(vol.ports[2], dpOut.port_a);
  connect(dpOut.port_b, sin.ports[1]);
end F;
