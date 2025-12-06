.include "macros.asm"
.include "data.asm"

.globl shopStart
.globl purchaseChicken
.globl exitShop

.data
shopHeader: .asciiz "\n==================[ SHOP ]==================\n"
shopOptions: .asciiz "What would you like to do?\n1) Purchase new chicken ($50)\n2) Exit\n"
currentBalance: .asciiz "\nYou currently have $"
shopSelection: .asciiz "Please make a selection: "

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
	move $t1, $v0
	beq $t1, 1, purchaseChicken
    beq $t1, 2, exitShop
    
purchaseChicken:
	# assumes player has >=$50
	subi $t0, $t0, 50
	la $t1, money # get address of money
	sw $t0, ($t1)
	
    # update chickenOwned
    la $t1, chickenOwned
    li $t0, 1
    sw $t0, ($t1)
    
    j getChickenName	# leave shop and name new chicken

exitShop:
	# send player back to menu
	j menuLoop
	
