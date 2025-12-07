# Final Project Group 9
# Orobosa Aghahowa, Kenny Huynh, Andrew Rabadi, Nicholas Scott
# 12/7/25

# prints a predefined string
.macro printString(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

# prints integer from register
.macro printInt(%int)
	li $v0, 1
	move $a0, %int
	syscall
.end_macro

# prints a character
.macro printChar(%char)
	li $v0, 11
	li $a0, %char
	syscall
.end_macro

# reads an integer
.macro getInt
	li $v0, 5
	syscall
.end_macro
