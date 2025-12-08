# Final Project Group 9
# Orobosa Aghahowa, Kenny Huynh, Andrew Rabadi, Nicholas Scott
# 12/7/25

.include "macros.asm"
.include "chickenFight.asm"
.include "shop.asm"

.data
menu1: .asciiz "Welcome to Chicken Fight\nPlease make a selection:\n(1) Play\n(2) Exit\nChoice: "
menu2: .asciiz "Main Menu:\n1) Play\n2) Store\n3) Quit\n\nCurrent Funds: $"
menu2Selection: .asciiz "\nPlease make a selection: "
playAgain: .asciiz "Would you like to play again?\n"
gift: .asciiz "\nThanks for playing!\nIn fact, have $50 and a chicken on the house!\n"
line: .asciiz "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
chickenPrompt: .asciiz "\nPlease enter a name for your chicken: "
invalidChickenString: .asciiz "\nTry again, but this time actually put in a name."
.align 2
chickenBuffer: .space 20
chickenCharNum: .byte 21

placeBetString1: .asciiz "\nPlace Your Bets!\n\nYou have $"
placeBetString2: .asciiz " to work with!\nEnter your bet: "
invalidBetString: .asciiz "\nInvalid bet; please try again.\n"
currentBet: .word 0
fightResult: .byte 0
wins: .byte 0

playerWinString: .asciiz "\nYour chicken won the fight!\n\n"
enemyWinString: .asciiz "\nYour chicken lost...\n\n"
gameOverString: .asciiz "Not enough money to continue.\nGame Over.\n"

invalidChoiceMsg: .asciiz "Invalid selection. Try again.\n"
chickenOwned: .byte 0
playerHP: .byte 100        #user starting hp
enemyHP: .byte 100        #enemy starting hp
money: .word 50
numWins: .asciiz "Fights won: "
earnings: .asciiz "You ended with $"

# ASCII art files
winArtFile:  .asciiz "win-art.txt"
loseArtFile: .asciiz "lose-art.txt"

# ASCII art buffer
.align 2
artBuffer: .space 2048

.globl main
.text
main:	# make sure to check "Initialize Program Counter to global 'main' if defined"
    printString(menu1)
    
    # get selection
    getInt
    move $t0, $v0

    beq $t0, 1, firstChicken
    beq $t0, 2, exit
    
    printString(invalidChoiceMsg)
    j main
    
menuLoop:	# menu if NOT player's first time
	printString(menu2)
	# print balance
	lw $t0, money
	printInt($t0)
	printString(menu2Selection)
	
	# get selection
	getInt
	move $t0, $v0
	beq $t0, 1, placeBet
	beq $t0, 2, shopStart
    	beq $t0, 3, exit
    
    printString(invalidChoiceMsg)
    j menuLoop

firstChicken:    # if the player just started
    printString(gift)
    printString(line)
    
    # update chickenOwned
    li $t0, 1
    sb $t0, chickenOwned
    
    j getChickenName

getChickenName:
	# write name to chickenBuffer
    printString(chickenPrompt)
    li $v0, 8
    la $a0, chickenBuffer
    lb $a1, chickenCharNum
    syscall

	move $t1, $a0		# copy for validation
	subi $t1, $t1, 1	# subtract 1 to fit checkIfValid
    j checkIfValid

# let user retry is name is invalid
checkIfValid:
    # shift to next byte 
    addi $t1, $t1, 1	# on the first go through, this just resets $t1 back to $a0
    lb $t0, ($t1)		# load single byte (one character) 
    
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
	# replace \n with \0 for later use
	sb $zero, ($t1)
	j checkIfValid	# return
	
checkASCII:
    blt $t0, 'a', invalidChicken

    # char is valid, proceed to next
    j checkIfValid

invalidChicken:
    printString(invalidChickenString)
    j getChickenName

placeBet:
    # print betting prompt
    printString(line)
    printString(placeBetString1)
    lw $t0, money
    printInt($t0)
    printString(placeBetString2)
    
    getInt
    move $t0, $v0      # bet entered

    lw $t1, money

    blez $t0, invalidBet		# bet less than 0
    bgt  $t0, $t1, invalidBet	# bet larger than current money

    # store bet
    sw $t0, currentBet

    # subtract bet from money
    sub $t1, $t1, $t0
    sw $t1, money

    j beginFight

invalidBet:
    printString(invalidBetString)
    j placeBet

beginFight:
    # reset HP
    li $t0, 100
    sb $t0, playerHP
    sb $t0, enemyHP

    # call fight (one cycle)
    j fightLoop

onPlayerWin:
    la $a0, winArtFile
    jal displayArt	# calls the ascii art display

    # add winnings (double)
    lw $t0, currentBet
    lw $t1, money
    
    add $t1, $t1, $t0
    add $t1, $t1, $t0
    sw $t1, money

    # increment wins
    lb $t0, wins
    addi $t0, $t0, 1
    sb $t0, wins

    printString(playerWinString)
    jal timer	# wait a bit before returning to menu
    j menuLoop

onEnemyWin:
    la $a0, loseArtFile
    jal displayArt	# calls the ascii art display

    printString(enemyWinString)
    jal timer

    # mark chicken as dead
    sb $zero, chickenOwned

    # game over if player cannot afford new chicken
    lw $t0, money
    blt $t0, 50, gameOver
    
    j menuLoop

gameOver:
    printString(gameOverString)
    j exit

displayArt:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $s1, $a0
    printChar('\n')	# newline for display 

    # open the ascii art file
    li $v0, 13
    move $a0, $s1
    li $a1, 0
    syscall
    move $s0, $v0

    # read from the ascii art file
    li $v0, 14
    move $a0, $s0
    la $a1, artBuffer
    li $a2, 2047
    syscall
    move $t0, $v0

    # store art into buffer to be printed
    la $t1, artBuffer
    add $t1, $t1, $t0
    sb $zero, 0($t1)

    # print the art
    li $v0, 4
    la $a0, artBuffer
    syscall

    printChar('\n')

    # close the art file
    li $v0, 16
    move $a0, $s0
    syscall

   # restore the registers and return
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

exit:
    # print number of wins
    printString(numWins)
    lb $t0, wins
    printInt($t0)
    # print new line character
    printChar('\n')
    
    # print final earnings
    printString(earnings)
    lb $t0, money
    printInt($t0)
    # print new line character
    printChar('\n')
    
    # exit program
    li $v0, 10
    syscall
