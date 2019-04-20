# inialize everything
# counter and counter max
pregame:
	# save the score and sort the existing scores
	addi $28, $0, 1;
	addi $0, $0, 0
	blt $0, $29, pregame
setupgame:
	addi $1, $0, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $1, $1, 20000
	addi $4, $0, 20000
	# lower pipes
	addi $7, $0, 120
	addi $8, $0, 320
	addi $9, $0, 520
	addi $10, $0, 720
	# upper pipes
	addi $11, $0, 120
	addi $12, $0, 320
	addi $13, $0, 520
	addi $14, $0, 720
	# pipe velocity
	addi $15, $0, 5
	# bird velocity
	addi $6, $0, 0
	# bird y, need a better initial value
	addi $5, $0, 250
	addi $17, $0, 0
	addi $16, $0, 0
	addi $19, $0, 95
	addi $18, $0, 100;
	addi $2, $0, 0;

pauseloop:
	addi $28, $0, 2;
	addi $4, $4, 1;
	# check collision flag
	blt $4, $1, pauseloop;
	blt $0, $29, resetloop;
	addi $17, $17, 1;
	blt $17, $19, 1
	addi $17, $0, 0
	jal waitbutton;

resetloop:
	addi $4, $0, 0;
	blt $0, $21, pauseloop
	j playgame

# start counter loop
waitbutton:
	addi $4, $0, 0;
	blt $0, $29, 1;
	j waitbutton
	jr $31
playgame:
	# noops loop
	addi $4, $4, 1
	# check collision flag
	blt $1, $4, 1
	j playgame
	bne $30, $0, handlecollision
aftercollision:
	bne $0, $25, initialreverse;
	j undoreverse;
afterreverse:
	bne $20, $0, increaselevel;
update:
	# here means that $4 counted up correctly
	# update score
	addi $16, $16, 1
	# update velocity
	addi $6, $6, 1
	# if flag is on, update y with buttons, otherwise act normally
	bne $0, $22, updatebirdy
	# if control = 0 set velocity to be -6 have to fix bug with addi and negative numbers
	bne $21, $0, 1
	addi $6, $0, -6
	# ybird = ybird + velocity
	addi $19, $0, 1;
	add $5, $5, $6;
	add $18, $18, $2;
updatepipes:
	# update pipe locations
	# lower pipes
	sub $7, $7, $15
	sub $8, $8, $15
	sub $9, $9, $15
	sub $10, $10, $15
	# upper pipes
	sub $11, $11, $15
	sub $12, $12, $15
	sub $13, $13, $15
	sub $14, $14, $15
	# reset counter
	addi $4, $0, 0
	j playgame;

handlecollision:
	addi $19, $0, 1;
	blt $24, $19, endgame;
	bne $19, $30, 1
	j movedown
	addi $19, $0, 3;
	bne $30, $19, 1;
	j moveup
	j endgame;

moveleft:
	addi $2, $0, -5;
	j aftercollision

movedown:
	addi $6, $0, 6;
	j aftercollision

moveup:
	addi $6, $0, -6;
	j aftercollision

undoreverse: 
	blt $0, $15, 1;
	addi $15, $0, 3;
	j afterreverse

initialreverse:
	addi $15, $0, -3;
	j afterreverse;

endgame:                                                                                                                                                                                                                          
	# save the score and sort the existing scores
	addi $28, $0, 3
	lw $16, 0($0);
	blt $19, $16, updatehighscore
continue:
	lw $17, 0($0)
	blt $0, $29, endgame
	jal waitbutton
	j setupgame

increaselevel:
	jal speedup
	j update

speedup:
	# if slow is one, direction is reversed, once it is off, direction is put back to normal
	bne $0, $25, reverse;
	addi $19, $0, 15;
	blt $19, $15, 1;
	addi $15, $15, 1;
	jr $31
reverse:
	addi $15, $15, -1;
	jr $31;

updatebirdy:
	blt $0, $21, 1;
	addi $5, $5, -2;
	blt $0, $23, 1;
	addi $5, $5, 2;
	j updatepipes

updatehighscore:
	sw $16, 0($0)
	sw $17, 10($0)
	j continue