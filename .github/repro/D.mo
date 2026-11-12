model D
  function f
    input String s;
    output String t;
  external "C" t = cpy(s) annotation(Include = "#include \"ModelicaUtilities.h\"
static const char* cpy(const char* s) { return ModelicaDuplicateStringWithErrorReturn(s); }");
  end f;
  parameter String s = f("a");
  Real x(start = 1, fixed = true);
equation
  der(x) = -x;
end D;
