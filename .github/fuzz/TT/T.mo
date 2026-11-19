package T
  model A Modelica.Blocks.Sources.CombiTimeTable tab(table = [0, 0; 1, 1], startTime = 0.3, timeScale = 0.7); end A;
  model B Modelica.Blocks.Sources.CombiTimeTable tab(table = [0, 0; 1, 1], startTime = 0.3); end B;
  model C Modelica.Blocks.Sources.CombiTimeTable tab(table = [0, 0; 1, 1], timeScale = 0.7); end C;
end T;
