start:
         addi $r1, $r1, 1
         adci $r2, $r2, 2
;;
         cmpeqi $p1, $r1, 1
;;
    (p1) addi $r2, $r2, 7
   (!p1) addi $r2, $r2, 77
;;
         addi $r30, $r0, 1
;;


.pos_x  dw  0
.pos_y  dw  0

