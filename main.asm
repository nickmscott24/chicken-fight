.include "macros.asm"

.data
menu:  .asciiz "Welcome to Chicken Fight\n"
select:  .asciiz "Please make a selection: \n"
option1:  .asciiz "(1) Play\n"
option2:  .asciiz "(2) Exit\n"
choice:  .asciiz "Choice: "
invalidSelect:  .asciiz "Invalid input, please try again.\n"
playAgain:  .asciiz "Would you like to play again?\n"
gift: .asciiz "\nThanks for playing!\nIn fact, have $50 and a chicken on the house!\n"
line: .asciiz "\n~~~~~~~~~~~~~~~\n"
chickenPrompt: .asciiz "\nPlease enter a name for your chicken: "
invalidChickenString: .asciiz "\nTry again, but this time actually put in a name."
.align 2
chickenBuffer: .space 20
chickenCharNum: .word 21

.text
start:
    printString(menu)

menuLoop:
    # WIP
    printString(line)
    printString(select)
    printString(option1)
    printString(option2)
    printString(choice)

    li $v0, 12    # take in either '1' or '2' for choices
    syscall
    move $t0, $v0

    beq $t0, '1', firstChicken
    beq $t0, '2', exit
    printString(invalidSelect)
    j menuLoop

firstChicken:    # if the player just started
    printString(gift)
    printString(line)
    j getChickenName

getChickenName:
	# write name to chickenBuffer
    printString(chickenPrompt)
    li $v0, 8
    la $a0, chickenBuffer
    lw $a1, chickenCharNum
    syscall

	move $t1, $a0	# copy for use
    j checkIfValid
    
checkIfValid:
    # let user retry is name is invalid
    lb $t0, ($t1)		# load single byte (one character) 
    addi $t1, $t1, 1	# shift to next byte 
    
	# continue to betting if string is valid
    beqz $t0, placeBet	# branch on null terminator
    
    # char is not \0, check if it's valid
    beq $t0, '\n', isNewLine		# specific case if newline
    blt $t0, 'A', invalidChicken	# 'A' is the start of valid ascii
    bgt $t0, 'z', invalidChicken	# 'z' is the end of valid ascii
    bgt $t0, 'Z', checkASCII		# between 'Z' and 'a' is invalid ascii

	# char is valid, proceed to next
	j checkIfValid

isNewLine:
	beq $t1, 1, invalidChicken	# invalid if the first char is \n
	
	# not the first character, valid
	j checkIfValid
	
checkASCII:
    blt $t0, 'a', invalidChicken

    # char is valid, proceed to next
    j checkIfValid

invalidChicken:
    printString(invalidChickenString)
    j getChickenName

placeBet:
    # WIP
    j exit

exit:
    li $v0, 10
    syscall
