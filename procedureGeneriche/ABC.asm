######### ALGORITMO A ##########################

	subi	$s0, $t0, 1	# togliere uno NON SAPPIAMO PERCHE riceve qui la lunghezza $s0
	
start:	move	$t0, $zero	# init counter		 
	la	$a3, buffer	# salvo il puntatore al buffer 

convert:lb	$t7, ($a3) 	# IN $T7 CE LA METTERA DA CAMBIARE
	li	$t3, 255	# load the module value
	li	$t2, 4		# load constant offset			
	li	$t4, 0		# flag 
	
decrip:	beq	$t4, $zero, crip 
	li 	$t5, -1		  # decifro 	
	mult	$t2, $t5
	mflo	$t2
	
crip:	add	$t7, $t7, $t2     # "cifro il carrattere"				
	div	$t7, $t3
	mfhi	$t7  		 		
	sb	$t7, 0($a3) # salvo il nuovo contenuto da stampare
	
	beq 	$t0, $s0, exit	# controllo di uscita
	add	$t0, $t0, 1	# update counter
	add	$a3, $a3, 1	# update char counter	
	j 	convert
	
################# fine A ############################## 

############# alg B #########################à
	subi	$s0, $t0, 1	# togliere uno NON SAPPIAMO PERCHE riceve qui la lunghezza $s0
	
start:	move	$t0, $zero	# init counter		 
	la	$a3, buffer	# salvo il puntatore al buffer 

convert:lb	$t7, ($a3) 	# IN $T7 CE LA METTERA DA CAMBIARE
	li	$t3, 255	# load the module value
	li	$t2, 4		# load constant offset			
	li	$t4, 0		# --------------------------------------->flag ----- gestito dall'esterno !
	
decrip:	beq	$t4, $zero, crip 
	li 	$t5, -1		  # decifro 	
	mult	$t2, $t5
	mflo	$t2
	
crip:	add	$t7, $t7, $t2     # "cifro il carrattere"				
	div	$t7, $t3
	mfhi	$t7  		 		
	sb	$t7, 0($a3) # salvo il nuovo contenuto da stampare
	
	beq 	$t0, $s0, exit	# controllo di uscita
	add	$t0, $t0, 1	# update counter
	add	$a3, $a3, 2	# update char counter	
	j 	convert
	
#########################################################

############# alg  #########################à
	# procedura di lunghezza forze non serve
	
start:		 
	la	$a3, buffer	# salvo il puntatore al buffer
	addi	$a3, $a3, 1 	# al posto di 1 deve essere un reg settato dall' esterno sara 0 se faccio A e B e
				# 1 se faccio C				
				
convert:lb	$t7, ($a3) 	# IN $T7 CE LA METTERA DA CAMBIARE
	beqz    $t7, exit
	li	$t3, 255	# load the module value
	li	$t2, 4		# load constant offset			
	li	$t4, 0		# flag 				-----------------0 - cirpta 1 decripta ---------------->flag ----- gestito dall'esterno !
	
decrip:	beq	$t4, $zero, crip 
	li 	$t5, -1		  # decifro 	
	mult	$t2, $t5
	mflo	$t2
	
crip:	add	$t7, $t7, $t2     # "cifro il carrattere"				
	div	$t7, $t3
	mfhi	$t7  		 		
	sb	$t7, 0($a3) # salvo il nuovo contenuto da stampare sullo stesso buffer !!!
	
				# se questo diventa una registro $t1 allora quando facciamo A dobbiamo assegnare $t1 = 1 , altrimenti $t1 =2 
	add	$a3, $a3, 2	# update char counter	--------------------------------------->flag ----- gestito dall'esterno !
	j 	convert
	
#########################################################	
		
			
					
		