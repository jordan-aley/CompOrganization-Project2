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

skipSpace:
	addi $t1, $t1,1
	j parse

fix:
	li $t7, -1
	la $t0, input
	add $t0,$t0,$t1
	lb $s0, ($t0)
	bge $t2, 5, invalidInput
	bge $t3, 1, invalidInput
	j check

check:
	beq $s0, 0, convert
	ble $s0, 47, notchar
	ble $s0, 57, int
	ble $s0, 86, uppercase
	ble $s0, 118, lowercase
	bge $s0, 119, notchar

notchar:
	addi $t1,$t1, 1
	beq $s0, 9,  shift
	beq $s0, 32, shift
	beq $s0, 10, convert
	j invalidInput

shift:
	addi $t3,$t3, -1
	j fix

int:
	ble $s0, 47, notchar
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	li $t5, 48
	sub $s0, $s0, $t5
	mul $t3, $t3, $t7
	j fix

uppercase:
	ble $s0, 64, notchar
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	li $t5, 55
	sub $s0, $s0, $t5
	mul $t3, $t3, $t7
	j fix

lowercase:
	ble $s0, 96, notchar
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	li $t5, 87
	sub $s0, $s0, $t5
	mul $t3, $t3, $t7
	j fix

convert:
	la $t0, input
	add $t0, $t0, $t6
	lb $s0, ($t0)
	addi $t2, $t2, -1
	addi $t6, $t6, 1
	blt $t2, 0, done
	move $t8, $t2
	j sort

sort:
	ble $s0, 57, num
	ble $s0, 86, up
	ble $s0, 118, low

num:
	li $t5, 48
	sub $s0, $s0, $t5
	li $t9, 1
	beq $t2, 0, merge
	li $t9, 30
	j exp

up:
	li $t5, 55
	sub $s0, $s0, $t5
	li $t9, 1
	beq $t2, 0, merge
	li $t9, 30
	j exp

lower:
	li $t5, 87
	sub $s0, $s0, $t5
	li $t9, 1
	beq $t2, 0, merge
	li $t9, 30
	j exp

done: jr $ra

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