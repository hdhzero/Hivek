start:
         add $r1, $zero, $r0
         sub $r4, $r3, $r5
;;
         add $r7, $r7, $r12
;;
         add $zero, $zero, $zero
    (p1) and $r1, $r2, $r3
;;

.var_x  dw      255
.var_y  dw      7
.var_z  dw      -1
.str    ascii "Hello"
