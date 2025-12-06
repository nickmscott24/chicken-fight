# prints a predefined string
.macro printString(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

# prints a given string literal
.macro print(%stringLiteral)
	.data
	string: .asciiz %stringLiteral
	
	.text
	printString(string)
.end_macro

# prints integer from register
.macro printInt(%int)
	li $v0, 1
	move $a0, %int
	syscall
.end_macro

# reads an integer
.macro getInt
	li $v0, 5
	syscall
.end_macro
