model Zbheat7007sR "Zbheat7007s with fixed start temperatures and inputs frozen at their t = 0 values"
  extends Zbheat7007s(C1(T(fixed = true), der_T(fixed = false)), C2(T(fixed = true), der_T(fixed = false)),
    C3(T(fixed = true), der_T(fixed = false)), C4(T(fixed = true), der_T(fixed = false)), C5(T(fixed = true), der_T(fixed = false)),
    src1(f = 0, damping = 0), src2(table = [0, 126.1; 1, 126.1]));
end Zbheat7007sR;
