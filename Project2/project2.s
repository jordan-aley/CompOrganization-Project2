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

invalidInput:
    #produces output
	li $v0, 4
	la $a0, newLine
	syscall
