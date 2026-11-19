model NS7 "same, r without fixed start"
  function step
    input Integer st;
    output Real r;
    output Integer sto;
  algorithm
    sto := mod(3*st + 1, 97);
    r := sto/97;
  end step;
  discrete Integer state;
  discrete Real r;
equation
  when sample(0, 0.1) then
    (r, state) = step(pre(state));
  end when;
initial equation
  pre(state) = 3;
end NS7;
