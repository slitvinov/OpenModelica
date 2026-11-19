model Zbheat7060sR "Zbheat7060s with fixed start temperatures and inputs frozen at their t = 0 values"
  extends Zbheat7060s(C1(T(fixed = true), der_T(fixed = false)), C2(T(fixed = true), der_T(fixed = false)),
    C3(T(fixed = true), der_T(fixed = false)),
    src1(amplitude = 0), src2(amplitude = 0), src3(table = [0, 24.27; 1, 24.27]));
end Zbheat7060sR;
