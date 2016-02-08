#David Futran
#Last Modified Date: May 18th, 2015
#Homework 3

#Pseudo Code:
#int myFunc(int x){
#    if(x==0||x==1||x==2) return 3;
#    else return ((myFunc(x-2)*(x-3))+4);
#}


#Registers Used:
#$t0: Integer submitted by user is stored here
#$t1: stores the result of the recurssion
#$t2: used to hold 3 for my base value in myFunc
#$t3: Holds 999, This is my Sentinel. If the integer entered equals this, The program terminates
#$v0: this is used with syscall as well as to store (n-2) as well as the aswer
#$a0: Is used to get input, output, and to retrieve values from stack
#$ra: return address. is used to return from recurrsive
#$sp: stack to hold the recursive values


#Program begins here:
    .text
    .globl main

main:
    lw $t3, var1            #load 999 into $t3

    #print the first message requesting a positive int from user:
    li  $v0,4               #print_string syscall code is 4
    la  $a0, mg1            #load first message
    syscall

    #get first integer from user
    li $v0,5                #read_int syscall code is 5
    syscall
    move $t0,$v0            #syscall results saved into $t0
    beq $t0,$t3,exit        #if 999 is entered, exit the program
    bgez $t0,noError        #if the integer is acceptable, goto noError

    #if the program reaches this point, then the int is nvalid. print the error message:
    li  $v0,4               #print_string syscall code is 4
    la  $a0, mg2            #load error message
    syscall
    la  $a0, nl            #load new line message
    syscall
    j main                  #go back to main so the user can input a new number

noError:
    #Call the recurssion
    move $a0, $t0           #put the integer entered into $a0 and then call the recursive function
    jal myFunc              #call the function myFunc
    move $t1, $v0           #store the final answer into $t1

    #print final message
    li  $v0,4               #print_string syscall code is 4
    la  $a0,mg3             #load last message
    syscall

    #print the result
    li $v0,1                #print_int syscall code is 1
    move $a0,$t1            #int to be printed must be loaded into a0
    syscall

    #print a new line
    li $v0,4                #print_string syscall code is 4
    la $a0,nl               #load string with new line
    syscall

    #jump back to main, thus repeating the program
    j main

exit:
    #exit the program:
    li $v0,10
    syscall

#Here is my recurrsive function. It is called myFunc
.globl myFunc
myFunc:
    #Initial steps:
    addi $sp, $sp, -8       #making room for $ra and one temporary value
    sw $ra, 4($sp)          #save $ra
    li $t2, 3               #temp value of 3 is loaded into $t2
    move $v0, $t2           #preloading return value as 3

    #the next 3 lines are my base case. If it equals 0,1, or 2 then end the function
    beq $a0, 0, myFuncDone
    beq $a0, 1, myFuncDone
    beq $a0, 2, myFuncDone

    #get n-3 to use later on:
    addi $t2,$a0,-3         #temp store an (n-3) in $t2 to use later on
    sw $t2, 0($sp)          #save my n-3 in the stack

    #calling the function recursively: func(n-2)
    addi $a0,$a0, -2        #get (n-2) into $a0
    jal myFunc              #call myFunc(n-2)

    lw $a0, 0($sp)          #retrieve my (n-3) value into $a0
    sw $v0, 0($sp)          #retrieve myFunc(n-2) value into $v0

    #computation is done here
    mul $v0,$a0,$v0         #multiply (n-3)*myFunc(n-2) and store into $v0
    addi $v0,$v0,4          #add 4 to the result of the previous line

myFuncDone:
    lw $ra, 4($sp)          #restore $ra
    addi $sp, $sp, 8        #restore $sp
    jr $ra                  #return back to caller


    .data
mg1: .asciiz "Enter an integer greater than or equal to 0: "
mg2: .asciiz "ERROR - integer is less than 0 "
mg3: .asciiz "The Result of the recurssion is: "
nl:  .asciiz "\n" #this will allow me to print a new line
var1: .word 999 #this will be used as a sentinel, so the user can exit the program

