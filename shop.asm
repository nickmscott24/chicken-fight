.data
shopHeader: .asciiz "\n==================[ SHOP ]==================\n"
shopOptions: .asciiz "What would you like to do?\n1) Purchase new chicken ($50)\n2) Exit\n"
currentBalance: .asciiz "\nYou currently have $"
shopSelection: .asciiz "\nPlease make a selection: "
hasChickenString: .asciiz "\nYou already have a chicken!\n"

.text
shopStart:
	# print menu
	printString(shopHeader)
	printString(shopOptions)
	# print current balance
	printString(currentBalance)
	lw $t0, money
	printInt($t0)
	printString(shopSelection)
	
	# get user selection
	getInt
	move $t0, $v0
	beq $t0, 1, purchaseChicken
    beq $t0, 2, exitShop
    
purchaseChicken:
	lb $t0, chickenOwned
	beq $t0, 1, hasChicken
	
	# player does not already have a chicken
	# assumes player has >=$50
	lw $t0, money
	subi $t0, $t0, 50
	sw $t0, money
	
    # update chickenOwned
    li $t0, 1
    sb $t0, chickenOwned
    
    j getChickenName	# leave shop and name new chicken

hasChicken:
	printString(hasChickenString)
	j shopStart
	
exitShop:
	# send player back to menu
	j menuLoop
	
