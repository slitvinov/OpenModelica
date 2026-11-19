model Zheat7065sR "Zheat7065s with fixed start temperatures and inputs frozen at their t = 0 values"
  extends Zheat7065s(C1(T(fixed = true), der_T(fixed = false)), C2(T(fixed = true), der_T(fixed = false)),
    C3(T(fixed = true), der_T(fixed = false)), C4(T(fixed = true), der_T(fixed = false)),
    src1(f = 0), src2(f = 0, damping = 0), src3(table = [0, 27.33; 1, 27.33]));
end Zheat7065sR;
