start:
        addi $r1, $r0, 12
        addi $r2, $r0, 0
;;
loop:
        cmpeqi $p1, $r1, 0
;;
  (!p1) addi $r2, $r2, 2
  (!p1) addi $r1, $r1, -1
;;
  (!p1) jc loop
   (p1) addi $r30, $r0, 1
;;
    addi $r0, $r0, 0
;;
    addi $r0, $r0, 0
;;
