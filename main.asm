.include "macros.asm"

.data
gift: .asciiz "Thanks for playing!\nIn fact, have $50 and a chicken on the house!\n"
line: .asciiz "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
chickenPrompt: .asciiz "\nPlease enter a name for your chicken: "
invalidChickenString: .asciiz "\nTry again, but this time actually put in a name."
.align 2
chickenBuffer: .space 20
chickenCharNum: .word 21

.text
main:
	# WIP
	j firstChicken

firstChicken:	# if the player just started
	printString(gift)
	printString(line)
	j getChickenName
	
getChickenName:
	printString(chickenPrompt)
	li $v0, 8
	la $a0, chickenBuffer
	lw $a1, chickenCharNum
	syscall
	
	jal checkForInvalid
	
		
	# if no issues, proceed to betting
	j placeBet

checkForInvalid:
	# let user retry is name is invalid
	lb $t0, 0($a0)
	blt $t0, 65, invalidChicken	# 65 is the start of valid ascii ('A')
	bgt $t0, 122, invalidChicken	# 122 is the end of valid ascii ('z')
	bgt $t0, 90, checkASCII		# 91-96 are invalid ascii
	
	# name is valid; proceed
	jr $ra
	
checkASCII:
	blt $t0, 97, invalidChicken
	
	# name is valid; proceed
	jr $ra

invalidChicken:
	printString(invalidChickenString)
	j getChickenName

placeBet:
	# WIP
	j exit
	
exit:
	li $v0, 10
	syscall
