.data
    #user input
	data: .space 1001
    #makes new line
	output: .asciiz "\n"
    #prints if output is not valid
	notvalid: .asciiz "Invalid input"

.text

main:
	#asks for input
	li $v0, 8
	la $a0, data
	li $a1, 1001
	syscall
	jal before
	j finish

before:
	la $t0,data
	add $t0,$t0,$t1
	lb $s0, ($t0)
	beq $s0, 0, convert
	beq $s0, 9, skip
	beq $s0, 32, skip
	move $t6, $t1
	j during

skip:
	addi $t1, $t1,1
	j before

during:
	li $t7, -1
	la $t0,data
	add $t0,$t0,$t1
	lb $s0, ($t0)
	bge $t2, 5, invalid
	bge $t3, 1, invalid
	j check

check:
	beq $s0, 0, convert
	ble $s0, 47, special
	ble $s0, 57, integer
	ble $s0, 86, capital
	ble $s0, 118, lowercase
	bge $s0, 119, special

special:
	addi $t1,$t1, 1
	beq $s0, 9,  gap
	beq $s0, 32, gap
	beq $s0, 10, convert
	j invalid

gap:
	addi $t3,$t3, -1
	j during			

integer:
	ble $s0, 47, special
	addi $t1, $t1, 1
	addi $t2, $t2, 1	
	
	li $t5, 48
	sub $s0, $s0, $t5

	mul $t3, $t3, $t7
	j during

capital:
	ble $s0, 64, special
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	
	li $t5, 55
	sub $s0, $s0, $t5

	mul $t3, $t3, $t7
	
	j during

lowercase:
	ble $s0, 96, special
	addi $t1, $t1, 1
	addi $t2, $t2, 1	
	
	li $t5, 87
	sub $s0, $s0, $t5

	mul $t3, $t3, $t7
	j during	

convert:
	la $t0, data
	add $t0,$t0,$t6
	lb $s0, ($t0)
	addi $t2,$t2, -1
	addi $t6, $t6, 1
	blt $t2,0,done
	move $t8, $t2
	j sort

sort:
	ble $s0, 57, num
	ble $s0, 84, upper
	ble $s0, 116, lower

num:
	li $t5, 48
	sub $s0, $s0, $t5
	li $t9, 1
	beq $t2, 0, combine
	li $t9, 30
	j exp

upper:
	li $t5, 55
	sub $s0, $s0, $t5
	li $t9, 1
	beq $t2, 0, combine
	li $t9, 30
	j exp

lower:
	li $t5, 87
	sub $s0, $s0, $t5
	li $t9, 1
	beq $t2, 0, combine
	li $t9, 30
	j exp

exp:
	ble $t8, 1, combine
	mul $t9, $t9, 30 
	addi $t8, $t8, -1
	j exp

combine:
	mul $s2, $t9, $s0
	add $s1, $s1, $s2

	li $t9, 1

	j convert

done: jr $ra	

finish:
	
	li $v0, 4
	la $a0, output
	syscall

	li $v0, 1
	
	move $a0, $s1
	syscall

	j Exit	
	
invalid:
	li $v0, 4
	la $a0, output
	syscall
	
	li $v0, 4
	la $a0, notvalid
	syscall
	j Exit

Exit:
	li $v0, 10
	syscall