model MB "planar pendulum (Revolute + FixedTranslation + Body) held by a MultiBody Spring to a fixed point"
  inner Modelica.Mechanics.MultiBody.World world(n = {0, -1, 0});
  Modelica.Mechanics.MultiBody.Joints.Revolute rev1(n = {0, 0, 1}, phi(start = -0.4796, fixed = true), w(start = -0.03477, fixed = true));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation ft1(r = {-0.6911, -0.4818, 0});
  Modelica.Mechanics.MultiBody.Parts.Body body1(m = 0.3113, r_CM = {0.2212, 0, 0}, I_33 = 0.002871);
  Modelica.Mechanics.MultiBody.Parts.Fixed fixed1(r = {-0.3052, -0.6741, 0});
  Modelica.Mechanics.MultiBody.Forces.Spring spr1(c = 18.61, s_unstretched = 0.2934);
equation
  connect(world.frame_b, rev1.frame_a);
  connect(rev1.frame_b, ft1.frame_a);
  connect(ft1.frame_b, body1.frame_a);
  connect(fixed1.frame_b, spr1.frame_a);
  connect(ft1.frame_b, spr1.frame_b);
end MB;
