start:
         addi $r1, $r1, 1
         adci $r2, $r2, 2
;;
         cmpeqi $p1, $r1, 1
;;
    (p1) addi $r2, $r2, 7
   (!p1) addi $r2, $r2, 77
;;
         lw $r5, $r0, pos_x
         lw $r6, $r0, pos_y
;;
         addi $r5, $r5, 2
;;
         sw $r5, $r0, pos_y
;;
         lw $r7, $r0, pos_y
         addi $r30, $r0, 1
;;
         addi $r0, $r0, 0
         addi $r0, $r0, 0
;;


.pos_x  dw  5
.pos_y  dw  8

