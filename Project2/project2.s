.data
    #user input
	input: .space 1001
    #makes new line
	newLine: .asciiz "\n"
    #prints if output is not valid
	notValid: .asciiz "Invalid input"

.text

main:
	#asks for input
	li $v0, 8
	la $a0, input
	li $a1, 1001
	syscall
	jal parse
	j finish

parse:
	la $t0, input
	add $t0, $t0, $t1
	lb $s0, ($t0)
	beq $s0, 0, convert
	beq $s0, 9, skipSpace
	beq $s0, 32, skipSpace
	move $t6, $t1
	j fix

fix:
	li $t7, -1
	la $t0, input
	add $t0,$t0,$t1
	lb $s0, ($t0)
	bge $t2, 5, invalidInput
	bge $t3, 1, invalidInput
	j check

skipSpace:
	addi $t1, $t1,1
	j parse

invalidInput:
    #produces output
	li $v0, 4
	la $a0, newLine
	syscall

    #prints "Invalid input"
	li $v0, 4
	la $a0, notValid
	syscall
    j exit

exit:
	li $v0, 10
	syscall