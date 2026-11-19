model NS "Integer state array initialized via pre(state) = f(seed), updated in a when with a tuple call"
  function init
    input Integer s;
    output Integer st[2];
  algorithm
    st := {s, s + 1};
  end init;
  function step
    input Integer st[2];
    output Real r;
    output Integer sto[2];
  algorithm
    sto := {st[2], mod(st[1] + st[2], 97)};
    r := sto[1]/97;
  end step;
  discrete Integer state[2];
  discrete Real r(start = 0, fixed = true);
initial equation
  pre(state) = init(3);
equation
  when sample(0, 0.1) then
    (r, state) = step(pre(state));
  end when;
end NS;
