#David Futran
#Last Modified Date: April 27th, 2015
#Homework 1 Part 2

#Pseudo Code:
#for(intj=20;j>10;j--){
#total=j+constant;
#println(“for jequal” +j+“,total equal”+total);
#}

#Registers Use:
#$t0: This holds J which equals 20
#$t1: This will hold the constant entered by the user
#$t2: This will hold the sum of J and the constant
#$t3: This will hold 10, and will be used to compare with J. If J equals 10, then the loop ends
#$t4: This will hold a 1, and I will subtract 1 from J for each cycle of the loop

    .text
    .globl main

main:
    lw $t0,var1         #load j=20 into $t0
    lw $t3,var2         #load 10 into $t3
    lw $t4,var3         #load 1 into $t4

    #print the first message:
    li  $v0,4           #print_string syscall code is 4
    la  $a0, mg1        #load first message asking for a constant
    syscall

    #get first integer
    li $v0,5            #read_int syscall code is 5
    syscall
    move $t1,$v0        #syscall results saved into $t1


loop:

    #computation
    add $t2,$t0,$t1     #make $t2 the sum of $t0 and $t1

    #print second message
    li  $v0,4           #print_string syscall code is 4
    la  $a0,mg2         #load message saying for j equals
    syscall

    #print j
    li $v0,1            #print_int syscall code is 1
    move $a0,$t0        #int to be printed must be loaded into a0
    syscall

    #print final message
    li  $v0,4           #print_string syscall code is 4
    la  $a0,mg3         #load last message saying total equals
    syscall

    #print total
    li $v0,1            #print_int syscall code is 1
    move $a0,$t2        #int to be printed must be loaded into a0
    syscall

    #print a new line
    li $v0,4            #print_string syscall code is 4
    la $a0,nl           #load string with new line
    syscall

    #count for loop
    sub $t0,$t0,$t4     #subtract 1 from $t0
    slt $t5,$t3,$t0     #test if $t0 is now less than 10
    beq $t5,$t4,loop    #if its not then go to loop

    #exit
    li $v0,10
    syscall

    .data
mg1: .asciiz "Enter a constant integer: "
mg2: .asciiz "For j equal "
mg3: .asciiz ", Total equals "
nl: .asciiz "\n"        #this will allow me to print a new line
var1: .word 20          #this will be our starting variable j/$t0
var2: .word 10          #this will be compared with j/$t0
var3: .word 1           #i will use this to subtract 1 from j/$t0

