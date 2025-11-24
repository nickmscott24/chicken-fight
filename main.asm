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
    blt $t0, 65, invalidChicken    # 65 is the start of valid ascii ('A')
    bgt $t0, 122, invalidChicken    # 122 is the end of valid ascii ('z')
    bgt $t0, 90, checkASCII        # 91-96 are invalid ascii

name is valid; proceed
    jr $ra

checkASCII:
    blt $t0, 97, invalidChicken

name is valid; proceed
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