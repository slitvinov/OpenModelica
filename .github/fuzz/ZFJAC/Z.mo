model Z
  Real m(start = 0, fixed = true);
  Real w;
equation
  m = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(w, 1, 1);
  der(m) = -w;
end Z;
