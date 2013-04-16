L1:
    add r1 r2 r4
    j loop

L8:
    sub r1, r5, r5
    lw r1, r4, 12
L9:
L10:
    break

.msg ascii "Hello, world!"
.age dw 0
.ctr dw 77
