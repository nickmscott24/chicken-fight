.data
playerMessage: .asciiz "\nYou dealt damage: "
enemyMessage: .asciiz "\nEnemy dealt damage: "
playerHPMessage: .asciiz "\nYour chicken HP: "
enemyHPMessage: .asciiz "\nEnemy chicken HP: "
playerWinMessage: .asciiz "\nYour chicken wins!"
enemyWinMessage: .asciiz "\nOpponent wins! Your chicken has been defeated!"

.text
fightLoop:
    # do player turn
    jal playerTurn
    
    # check if enemy dead
    lb $t0, enemyHP
    blez $t0, onPlayerWin
     
    # do enemy turn
    jal enemyTurn
    
    # check if player dead
    lb $t0, playerHP
    blez $t0, onEnemyWin
	
	# no one died; loop
	j fightLoop
    
playerTurn:
    # generate the random damage from 1 to 10
    la $t0, getDamage
    jalr $t1, $t0	# damage stored in $t0
    
    # print out damage message
    printString(playerMessage)
    printInt($t0)

    # subtract damage from enemy HP
    lb $t1, enemyHP
    sub $t1, $t1, $t0
    sb $t1, enemyHP
    
    # return to loop
    jr $ra

enemyTurn:
	# generate the random damage from 1 to 10
    la $t0, getDamage
    jalr $t1, $t0	# damage stored in $t0
    
    # print out damage message
    printString(enemyMessage)
    printInt($t0)

    # subtract damage from player HP
    lb $t1, playerHP
    sub $t1, $t1, $t0
    sb $t1, playerHP
    
    # return to loop
    jr $ra

getDamage:
	# get random number from 1-10
	li $v0, 42
    li $a0, 0   
    li $a1, 20			# upper bound - 20
    syscall
    addi $a0, $a0, 10	# increase range to 10-30
    move $t0, $a0		# damage = random number in $a0
    
    jr $t1