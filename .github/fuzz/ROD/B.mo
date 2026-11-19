model B
  inner Modelica.Mechanics.MultiBody.World world;
  Modelica.Mechanics.MultiBody.Joints.Revolute rev(phi(start = 0, fixed = true), w(start = 0, fixed = true));
  Modelica.Mechanics.MultiBody.Parts.Body body(m = 1, r_CM = {1, 0, 0}, I_33 = 0.1);
equation
  connect(world.frame_b, rev.frame_a);
  connect(rev.frame_b, body.frame_a);
end B;
