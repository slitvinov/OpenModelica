model TT "CombiTimeTable with startTime and timeScale: old backend output stays 0"
  Modelica.Blocks.Sources.CombiTimeTable tab(table = [0.0, 0.244; 0.21, -0.643; 0.31, -0.898; 0.7, 0.304; 1.63, 0.312; 1.87, -0.507; 2.01, -0.364],
    startTime = 0.042, timeScale = 0.723);
  Real z(start = 0, fixed = true);
equation
  der(z) = -2.483*z + tab.y[1];
end TT;
