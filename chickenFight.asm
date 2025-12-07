.data
playerDamage1: .asciiz " hit Enemy for "
playerDamage2: .asciiz " damage\n"
enemyDamage1: .asciiz "Enemy hit "
enemyDamage2: .asciiz " for "
enemyDamage3: .asciiz " damage\n"
playerHPMessage: .asciiz "'s HP: "
enemyHPMessage: .asciiz "\nEnemy's HP: "

.text
fightLoop:
	printChar('\n')	# print new line character
    
    # do player turn
    jal playerTurn
    jal printHealth
    jal timer
    
    # check if enemy dead
    lb $t0, enemyHP
    blez $t0, onPlayerWin
    
	printChar('\n')	# print new line character
    
    # do enemy turn
    jal enemyTurn
	jal printHealth
    jal timer
    
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
    printString(chickenBuffer)	# [player]
    printString(playerDamage1)	# hit Enemy for
    printInt($t0)				# [damage]
    printString(playerDamage2)	# damage

    # subtract damage from enemy HP
    lb $t1, enemyHP
    sub $t1, $t1, $t0
    bltz $t1, setEnemyZero	# prevent negative HP
    sb $t1, enemyHP
    
    # return to loop
    jr $ra
    
setEnemyZero:
	sb $zero, enemyHP
	jr $ra	# return to loop

enemyTurn:
	# generate the random damage from 1 to 10
    la $t0, getDamage
    jalr $t1, $t0	# damage stored in $t0
    
    # print out damage message
    printString(enemyDamage1)	# Enemy hit
    printString(chickenBuffer)	# [player]
    printString(enemyDamage2)	# for
    printInt($t0)				# [damage]
    printString(enemyDamage3)	# damage

    # subtract damage from player HP
    lb $t1, playerHP
    sub $t1, $t1, $t0
    bltz $t1, setPlayerZero	# prevent negative HP
    sb $t1, playerHP
    
    # return to loop
    jr $ra

setPlayerZero:
	sb $zero, playerHP
	jr $ra	# return to loop

getDamage:
	# get random number from 1-10
	li $v0, 42
    li $a0, 0   
    li $a1, 20			# upper bound - 20
    syscall
    addi $a0, $a0, 10	# increase range to 10-30
    move $t0, $a0		# damage = random number in $a0
    
    jr $t1

printHealth:
	# print player health
	printString(chickenBuffer)		# [player]
	printString(playerHPMessage)	# 's HP:
	lb $t0, playerHP
	printInt($t0)
	
	# print enemy health
	printString(enemyHPMessage)		# Enemy's HP:
	lb $t0, enemyHP
	printInt($t0)
	
	printChar('\n')	# print new line character
    
    jr $ra
    
timer:
	# wait for about a second before continuing
	li $t0, 2000000
	li $t1, 0
	
	j timerLoop

timerLoop:
	addi $t1, $t1, 1
	blt $t1, $t0, timerLoop
	
	# timer complete, return to fightLoop
	jr $ra
