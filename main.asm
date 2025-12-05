.include "ui.asm"
.include "chickenFight.asm"

.data
menu: .asciiz "Welcome to Chicken Fight\n"
select: .asciiz "Please make a selection: \n"
option1: .asciiz "(1) Play\n"
option2: .asciiz "(2) Exit\n"
choice: .asciiz "Choice: "
invalidSelect: .asciiz "Invalid input, please try again.\n"
playAgain: .asciiz "Would you like to play again?\n"
gift: .asciiz "\nThanks for playing!\nIn fact, have $50 and a chicken on the house!\n"
line: .asciiz "\n~~~~~~~~~~~~~~~\n"
chickenPrompt: .asciiz "\nPlease enter a name for your chicken: "
invalidChickenString: .asciiz "\nTry again, but this time actually put in a name."
.align 2
chickenBuffer: .space 20
chickenCharNum: .word 21

placeBetString: .asciiz "\nEnter your bet: "
invalidBetString: .asciiz "\nInvalid bet; please try again.\n"
money: .word 50
chickenOwned: .word 0
fightResult: .word 0
wins: .word 0
currentBet: .word 0

.text
menuLoop:
    printString(bannerTop)
    printString(mainMenuTitle)
    printString(menuLine)
    printString(menuOptionsText)

    li $v0, 5           #read integer choice
    syscall
    move $t0, $v0

    beq $t0, 1, firstChicken
    beq $t0, 2, exit
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
    printString(placeBetString)

    li $v0, 5
    syscall
    move $t0, $v0      # bet entered

    la $t1, money
    lw $t2, 0($t1)

    blez $t0, invalidBet
    bgt  $t0, $t2, invalidBet

    # store bet
    la $t3, currentBet
    sw $t0, 0($t3)

    # subtract bet
    sub $t2, $t2, $t0
    sw $t2, 0($t1)

    j beginFight

invalidBet:
    printString(invalidBetString)
    j placeBet

beginFight:
    # reset HP
    li $t0, 100
    la $t1, playerHP
    sw $t0, 0($t1)

    li $t0, 100
    la $t2, enemyHP
    sw $t0, 0($t2)

    # call fight (one cycle)
    jal fight

    # read result
    la $t3, fightResult
    lw $t4, 0($t3)

    li $t5, 1
    beq $t4, $t5, playerWins

    li $t5, 2
    beq $t4, $t5, enemyWins

    # nobody died ? refund bet
    la $t6, currentBet
    lw $t7, 0($t6)

    la $t8, money
    lw $t9, 0($t8)

    add $t9, $t9, $t7
    sw $t9, 0($t8)

    j menuLoop

playerWins:
    # add winnings (double)
    la $t0, currentBet
    lw $t1, 0($t0)

    la $t2, money
    lw $t3, 0($t2)
    add $t3, $t3, $t1
    add $t3, $t3, $t1
    sw $t3, 0($t2)

    # increment wins
    la $t4, wins
    lw $t5, 0($t4)
    addi $t5, $t5, 1
    sw $t5, 0($t4)

    printString("Your chicken wins the fight!\n")
    j menuLoop

enemyWins:
    printString("Your chicken died!\n")

    # mark chicken as dead
    la $t0, chickenOwned
    li $t1, 0
    sw $t1, 0($t0)

    # check money for auto-buy
    la $t2, money
    lw $t3, 0($t2)

    li $t4, 20
    blt $t3, $t4, gameOver

    # auto-buy chicken
    sub $t3, $t3, $t4
    sw $t3, 0($t2)

    li $t1, 1
    sw $t1, 0($t0)

    printString("You bought a new chicken!\n")
    j menuLoop

gameOver:
    printString("Not enough money to continue.\nGame Over.\n")
    j exit

exit:
    li $v0, 10
    syscall
