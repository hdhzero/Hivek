# x0 = r1
# y0 = r2
# x1 = r3
# x4 = r4
draw_line:
    # boolean steep = abs(y1 - y0) > abs(x1 - x0)
    
    

L1:
          add $r1, $r2, $r4
;;
          or  $r7, $r5, $r3
;;
L8:
   (!p1) sub $r1, $r5, $r5
;;
          lw $r1, $r0, msg
          andp p1, $r12, $r7
;;
   (p1)  jalc $L8
;;
          jr $r7
;;
L9:
L10:

.msg ascii "Hello, world!"
.age dw 0
.ctr dw 77

