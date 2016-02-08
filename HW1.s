#David Futran
#Last Modified Date: April 27th, 2015
#Homework 1 Part 1

#Pseudo Code:
#int integer1;
#int integer2;
#main:
#cout<<"Enter an integer A between -10 and 0: ";
#cin>>integer1;
#if(integer1==1) exit program;
#if(integer1>0||integer1<-10) goto main;
#two:
#cout<<"Enter another integer B between -10 and 0: ";
#cin>>integer2;
#if(integer2==1) exit program;
#if(integer2>0||integer2<-10) goto two;
#integer1=(integer1+2(integer2))*8;
#cout<<"(integer1+2*integer2)*8 = "<<integer1;
#goto main;


#Registers Use:
#$t0: First Integer submitted by user. Later the total will be stored here
#$t1: Second Integer submitted by user. Later it holds the second integer multiplied by 2
#$t2: Holds 10. Later I add 10 to the integer entered so I can check if the sum is less than 0 and therefore invalid
#$t3: Holds 1, This is my Sentinel. If the integer entered equals this, The program terminates


#Program:

    .text
    .globl main

main:
    lw $t2,var1         #load $t2 with 10
    lw $t3,var2         #load $t3 with 1

    #print the first message:
    li  $v0,4           #print_string syscall code is 4
    la  $a0, mg1       #load first message
    syscall

    #get first integer
    li $v0,5            #read_int syscall code is 5
    syscall
    move $t0,$v0        #syscall results saved
    beq $t0,$t3,exit    #if 1 is entered, exit the program
    bgtz $t0,main       #is an integer greater then 0 is entered, go to main so the user can re-enter an integer
    add $t2,$t0,$t2     #add 10 to the integer entered
    bltz $t2,main       #if it is now less than 0, go to main so user can re-enter an integer

two:
    lw $t2,var1         #load 10 into $t2 again

    #print the second message:
    li  $v0,4           #print_string syscall code is 4
    la  $a0,mg2         #load first message
    syscall

    #get first integer
    li $v0,5            #read_int syscall code is 5
    syscall
    move $t1,$v0        #syscall results saved
    beq $t0,$t3,exit    #if 1 is entered, exit the program
    bgtz $t1,two        #if an integer greater than 0 is entered, go to two so the user can re-enter a second integer
    add $t2,$t1,$t2     #add 10 to the second integer entered
    bltz $t2,two        #if the sum is less than 0, go to two so the user can re-enter a second integer



    #computation
    add $t1,$t1,$t1     #add the second integer to itself resulting in the second integer being multiplied by 2
    add $t0,$t0,$t1     #add t0 and t1. store into t0 (add the two integers)
    sll $t0,$t0,3       #shift right by 3. this multiplies the sum by 8. store into $t0


    #print final message
    li  $v0,4           #print_string syscall code is 4
    la  $a0,mg3         #load last message
    syscall

    #print the sum
    li $v0,1            #print_int syscall code is 1
    move $a0,$t0        #int to be printed must be loaded into a0
    syscall

    #print a new line
    li $v0,4            #print_string syscall code is 4
    la $a0,nl           #load string with new line
    syscall

    #jump back to main, thus repeating the program
    j main

exit:
    #exit
    li $v0,10
    syscall

    .data
mg1: .asciiz "Enter an integer A between -10 and 0: "
mg2: .asciiz "Enter another integer B between -10 and 0: "
mg3: .asciiz "(integer1+2*integer2)*8 = "
nl: .asciiz "\n" #this will allow me to print a new line
var1: .word 10 #this will be used to see if the integer entered is less than -10
var2: .word 1 #this will be used as a comparison, so the user can exit the program

