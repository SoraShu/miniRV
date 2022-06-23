    lui   s1,0xFFFFF
START:
    lw    s0,0x70(s1)       # load addr

    andi  a0,s0,0xFF        # get A
    srli  s0,s0,8
    andi  a1,s0,0xFF        # get B
    srli  s0,s0,13
    andi  t0,s0,0x7         # get op

    # switch(t0)
    beq   t0,zero,NONE
    addi  t0,t0,-1
    beq   t0,zero,ADD
    addi  t0,t0,-1
    beq   t0,zero,SUB
    addi  t0,t0,-1
    beq   t0,zero,AND
    addi  t0,t0,-1
    beq   t0,zero,OR
    addi  t0,t0,-1
    beq   t0,zero,LEFT
    addi  t0,t0,-1
    beq   t0,zero,RIGHT
    addi  t0,t0,-1
    beq   t0,zero,MUL
    
    
NONE:
    jal   zero,END          # NONE op

ADD:
    add   a2,a0,a1          # ADD op
    jal   zero,END

SUB:
    xori  a3,a1,0xFF        # SUB op
    add   a2,a0,a3          # 8bit sub
    jal   zero,END

AND:
    and   a2,a0,a1          # AND op
    jal   zero,END

OR:
    or    a2,a0,a1          # or op
    jal   zero,END

LEFT:
    sll   a2,a0,a1          # LEFT shift op
    jal   zero,END

RIGHT:
    slli   a2,a0,24         # RIGHT shift op
    sra    a2,a2,a1
    srli   a2,a2,24
    jal    zero,END

MUL:
    xori  a3,a1,0xFF        # MUL
    addi  a3,a3,1
    andi  a3,a3,0xFF        # a3 = -a1
    slli  a0,a0,1           # in case of convince
    slli  a1,a1,7
    slli  a3,a3,7
    addi  s2,zero,7         # s2 = 7
    addi  s3,zero,0         # set s3 as cn
    addi  a2,zero,0         # set a2 as return
    lui   s10,0x4
    
MLOOP:
    andi  s4,a0,0x3         # MLOOP : get last 2 bit
    # switch((s4) : a simple booth
    beq   s4,zero,MSHIFT
    addi  s4,s4,-1
    beq   s4,zero,MP
    addi  s4,s4,-1
    beq   s4,zero,MN
    addi  s4,s4,-1
    beq   s4,zero,MSHIFT
    
MSHIFT:
    beq   s3,s2,MEND        # don't shift if s3 reach 7
    and   t0,a2,s10         # get sign: 0,0000000,0000000  0100,0000,0000,0000
    srli  a2,a2,1           
    add   a2,a2,t0
    srli  a0,a0,1
    addi  s3,s3,1
    jal   zero,MLOOP

MP:
    add   a2,a2,a1          # add +B
    jal   zero,MSHIFT
    
MN:
    add   a2,a2,a3 # add -B
    jal   zero,MSHIFT

MEND:
    jal   zero,END # MEND
    
END:
    sw    a2,0x60(s1)
    sw    a2,0x00(s1)
    jal   zero,START
