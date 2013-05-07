start:
        addi $r1, $r0, 12
        addi $r2, $r0, 0
;;
loop:
        cmpeqi $p1, $r1, 0
        addi $r0, $r0, 0
;;
  (!p1) addi $r2, $r2, 2
  (!p1) addi $r1, $r1, -1
;;
  (!p1) jc loop
   (p1) addi $r1, $r0, 7
;;
    addi $r3, $r0, 0
;;
loop2:
    cmpeqi $p2, $r1, 0
    addi $r0, $r0, 0
;;
    (!p2) addi $r3, $r3, 3
    (!p2) addi $r1, $r1, -1
;;
    (!p2) jc loop2
    (p2) addi $r30, $r0, 1
;;
    addi $r0, $r0, 0
;;
