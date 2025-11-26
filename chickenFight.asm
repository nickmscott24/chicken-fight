.data
playerHP: .word 100        #user starting hp
enemyHP: .word 100        #enemy starting hp
newLine: .asciiz "\n"
playerMessage: .asciiz "You dealt damage: "
enemyMessage: .asciiz "Enemy dealt damage: "
playerHPMessage: .asciiz "Your chicken HP: "
enemyHPMessage: .asciiz "Enemy chicken HP: "
playerWinMessage: .asciiz "Your chicken wins!"
enemyWinMessage: .asciiz "Opponent wins! Your chicken has been defeated!"

.text
.globl fight
fight:

fightLoop:

    #generate the random damage from 0 to 10
    li $v0, 42
    li $a0, 1        #lower bound - 1
    li $a1, 10       #upper bound - 10
    syscall
    move $t0, $a0    #damage = random number in $a0

    #print out damage message
    li $v0, 4
    la $a0, playerMessage
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    #subtract damage from enemy HP
    la $t1, enemyHP
    lw $t2, 0($t1)           #t2 = current enemy hp
    sub $t2, $t2, $t0        #new hp = hp - damage

    #prevent negative HP
    bltz $t2, enemyZero
    sw $t2, 0($t1)
    j checkEnemyDead

enemyZero:
    li $t2, 0
    sw $t2, 0($t1)

checkEnemyDead:
    #print enemy HP
    li $v0, 4
    la $a0, enemyHPMessage
    syscall

    li $v0, 1
    move $a0, $t2
    syscall

    #if enemey HP reaches 0, then user iwns
    beqz $t2, playerWins

    #insert newLine
    li $v0, 4
    la $a0, newLine
    syscall

    #generate the random damage from 0 to 10
    li $v0, 42
    li $a0, 1   #lower bound - 1
    li $a1, 10  #upper bound - 10
    syscall
    move $t0, $a0    #damage = random number in $a0

    #print amount of damage dealt
    li $v0, 4
    la $a0, enemyMessage
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    #subtract from player HP
    la $t1, playerHP
    lw $t2, 0($t1)
    sub $t2, $t2, $t0

    #prevent negative HP
    bltz $t2, playerZero
    sw $t2, 0($t1)
    j checkPlayerDead

playerZero:
    li $t2, 0
    sw $t2, 0($t1)

checkPlayerDead:
    #print out player HP
    li $v0, 4
    la $a0, playerHPMessage
    syscall

    li $v0, 1
    move $a0, $t2
    syscall

    #if player HP reaches 0, then opponent wins
    beqz $t2, enemyWins

    #insert newLine
    li $v0, 4
    la $a0, newLine
    syscall



playerWins:
    li $v0, 4
    la $a0, playerWinMessage
    syscall
    
    li $v0, 10
    syscall

enemyWins:
    li $v0, 4
    la $a0, enemyWinMessage
    syscall
    
    li $v0, 10
    syscall
