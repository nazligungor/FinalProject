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
	addi $18, $0, 0
	addi $16, $0, 0
	addi $19, $0, 95
	addi $18, $0, 100;
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
	bne $30, $0, endgame
	blt $1, $4, 1
	j playgame
	bne $0, $20, increaselevel;
update:
	# here means that $4 counted up correctly
	# update score
	addi $16, $16, 1
	# update velocity
	addi $6, $6, 1
	# update control, for now, make reg21 this
	add $2, $0, $21
	# if control = 0 set velocity to be -6 have to fix bug with addi and negative numbers
	bne $2, $0, 1
	addi $6, $0, -6
	# ybird = ybird + velocity
	add $5, $5, $6
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
	jal updatebirdx
	addi $4, $0, 0
	j playgame;
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
	addi $19, $0, 2000;
	sub $1, $1, $18;
	jr $31
updatebirdx:
	addi $19, $0, 1;
	bne $19, $22, return;
	blt $0, $23, 1;
	addi $18, $18, -2;
	blt $0, $24, 1;
	addi $18, $18, 2;
return:
	jr $31;
updatehighscore:
	sw $16, 0($0)
	sw $17, 10($0)
	j continue
