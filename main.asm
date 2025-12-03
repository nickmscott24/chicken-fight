.include "macros.asm"
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
money: .word 50
chickenOwned: .word 0
playerHP: .word 100
enemyHP: .word 100
fightResult: .word 0
wins: .word 0
currentBet: .word 0

.text
start:
    printString(menu)

menuLoop:
    jal uiBanner
    jal uiMenu

    li $v0, 5           #read integer choice
    syscall
    move $t0, $v0

    beq $t0, 1, firstChicken
    beq $t0, 2, exit
    jal uiInvalid
    j menuLoop

    li $v0, 12          # read char '1' or '2'
    syscall
    move $t0, $v0

    beq $t0, '1', firstChicken
    beq $t0, '2', exit
    printString(invalidSelect)
    j menuLoop

firstChicken:            # if the player just started
    printString(gift)
    printString(line)

    # give money and chicken only once
    la $t1, chickenOwned
    lw $t2, 0($t1)
    bnez $t2, getChickenName      # already owns a chicken

    # give first chicken
    li $t3, 1
    sw $t3, 0($t1)

    # give money
    la $t4, money
    li $t5, 50
    sw $t5, 0($t4)

    j getChickenName

getChickenName:
    printString(chickenPrompt)

    li $v0, 8
    la $a0, chickenBuffer
    lw $a1, chickenCharNum
    syscall

    jal checkForInvalid

    j placeBet

checkForInvalid:
    # always load from chickenBuffer
    la $t9, chickenBuffer
    lb $t0, 0($t9)

    blt $t0, 65, invalidChicken        # below 'A'
    bgt $t0, 122, invalidChicken       # above 'z'
    bgt $t0, 90, checkASCII            # between 'Z' and 'a'
    jr $ra

checkASCII:
    blt $t0, 97, invalidChicken        # reject ASCII 91–96
    jr $ra

invalidChicken:
    printString(invalidChickenString)
    j getChickenName

placeBet:
    printString("Enter your bet: ")

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
    printString("Invalid bet!\n")
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
