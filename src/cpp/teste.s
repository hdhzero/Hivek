L1:
          add r01, r02, r04
;;
          or  r07, r05, r03
;;
L8:
   (!p01) sub r01, r05, r05
;;
          lw r01, r00, msg
          andp p01, r12, r07
;;
   (p01)  jalc L8
;;
          jr r07
;;
L9:
L10:

.msg ascii "Hello, world!"
.age dw 0
.ctr dw 77

