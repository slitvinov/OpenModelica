model W1 "when u ... elsewhen not u: the not u branch never fires with --newBackend"
  Boolean u = time > 2 and time < 4;
  Boolean d(start = false, fixed = true);
algorithm
  when u then
    d := true;
  elsewhen not u then
    d := false;
  end when;
end W1;
