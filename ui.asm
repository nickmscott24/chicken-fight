#CS 2640
#11/24/2025
#Final Project Group 9
#Andrew Rabadi, Kenny Huynh, Orobosa Aghahowa, Nicholas Scott

.include "macros.asm"

.data
bannerTop: .asciiz  "\n==================[ CHICKEN FIGHT ]==================\n"
menuLine: .asciiz  "------------------------------------------------------\n"

mainMenuTitle: .asciiz "\nMAIN MENU\n"
menuOptionsText: .asciiz "1) Play\n2) Store\n3) State\n4) Save Game\n5) Load Game\n6) Quit\nChoice: "

invalidChoiceMsg: .asciiz "Invalid selection. Try again.\n"

hpLabelPlayer: .asciiz "Player HP: "
hpLabelEnemy: .asciiz "Enemy  HP: "

barStart: .asciiz "["
barEnd: .asciiz "]"
barFull: .asciiz "#"
barEmpty: .asciiz "-"

typingDots: .asciiz "."
typingDone: .asciiz " Done!\n"

uiNewLine: .asciiz "\n"

.text

uiPrintHPBars:
    #print player label
    printString(hpLabelPlayer)
    la $t0, hpLabelPlayer
    jal printBar
    printString(uiNewLine)

    #print enemy label
    printString hpLabelEnemy
    move $t0, $a1
    jal printBar
    jal uiNewLine

    jr $ra

printBar:
    # print '['
    printString barStart

    #compute number of filled segments (#)
    #bar = 20 characters
    li $t1, 20
    mul $t2, $t0, $t1       #HP * 20
    li $t3, 100
    div $t2, $t3
    mflo $t4                 #t4 = filled count

    #print full chars
    move $t5, $zero
full_Loop:
    beq $t5, $t4, emptyCalc
    printString barFull
    addi $t5, $t5, 1
    j full_Loop

emptyCalc:
    #empty = 20 - filled
    li $t6, 20
    sub $t6, $t6, $t4
    move $t7, $zero

emptyLoop:
    beq $t7, $t6, closeBar
    printString barEmpty
    addi $t7, $t7, 1
    j emptyLoop

closeBar:
    printString barEnd
    jr $ra

uiTyping:
    #print three dots
    li $t0, 3
typingLoop:
    beqz $t0, typingFinish
    printString typingDots
    jal uiPause
    addi $t0, $t0, -1
    j typing_loop

typingFinish:
    printString typingDone
    jr $ra


uiPause:
    li $t1, 500000
pauseLoop:
    addi $t1, $t1, -1
    bgtz $t1, pauseLoop
    jr $ra
