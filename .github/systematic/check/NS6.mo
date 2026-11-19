model NS6 "pre(state) = 3, tuple update (r, state) = step(pre(state))"
  function step
    input Integer st;
    output Real r;
    output Integer sto;
  algorithm
    sto := mod(3*st + 1, 97);
    r := sto/97;
  end step;
  discrete Integer state;
  discrete Real r(start = 0, fixed = true);
equation
  when sample(0, 0.1) then
    (r, state) = step(pre(state));
  end when;
initial equation
  pre(state) = 3;
end NS6;
