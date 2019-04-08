.data
	buffer: 	.asciiz		"Lorem ipsum"
	support:	.space		255
	space:		.asciiz		"\n"

.align 2
.text

main:
	la	$a3, buffer
	li	$a1, 0
	jal	C
	
	la	$a3, buffer		
	li	$a1, 0
	jal	B
	
	la	$a3, buffer
	li	$a1, 0
	jal	A
	
	jal	algD
	move	$a3, $v1
	

	li	$v0, 4		# messaggio cifrato
	#la	$a0, buffer
	la	$a0, support
	syscall
	
	li	$v0, 4		# spazio tra le stampe
	la	$a0, space
	syscall
	
	jal	algD
	move	$a3, $v1
	
	# devo assegnare 
	# la	$a3, buffer
	li	$a1, 1
	jal	A
	
	#la	$a3, buffer		
	li	$a1, 1
	jal	B

	#la	$a3, buffer
	li	$a1, 1
	jal	C
	

	li	$v0, 4
	la	$a0, buffer
	syscall
	
	li 	$v0,10
	syscall	


# PROCEDURA DEDICATA AL SETTAGGIO DEL CONPORTAMENTO PER L'ALGORITMO A
# PARAMETRI : $S1 , si aspetta 0 per criptare oppure 1 per decriptare 
#
A:
	li	$s0, 0
	move	$s1, $a1
	li	$s2, 1	
	j	shifter

# PROCEDURA DEDICATA AL SETTAGGIO DEL CONPORTAMENTO PER L'ALGORITMO B
# PARAMETRI : $S1 , si aspetta 0 per criptare oppure 1 per decriptare 
#
B:
	li	$s0, 0
	move	$s1, $a1
	li	$s2, 2	
	j	shifter

# PROCEDURA DEDICATA AL SETTAGGIO DEL CONPORTAMENTO PER L'ALGORITMO C
# PARAMETRI : $S1 , si aspetta 0 per criptare oppure 1 per decriptare 
#
C:
	li	$s0, 1
	move	$s1, $a1
	li	$s2, 2	
	j	shifter


# PROCEDURA GENERICA CHE SVOLGERA IL CIFRATURA E LA DECIFRATURA DEGLI ALGORITMI A - B - C 
# : il suo confortamento sarà definito dal settaggio di alcuni flag, da procedure dedicate 
#  parametri :
#	$s0 <--  offset di inizio di scorrimento del buffer
#	$s1 <--  flag distinzione tra operazione di CRIFRATURA e DECIFRATURA
#	$s2 <--	 offset dedicato al passo di scorrimento del buffer
# viene utilizzato il solito buffer

shifter:	
		 
	#la	$a3, buffer	# salvo il puntatore al buffer
	add	$a3, $a3, $s0 	# definiamo l'indice di partenza	
								
convert:lb	$t0, ($a3) 	# $t0 carichiamo la lettera da cifrare
	beqz    $t0, exit	# controlliamo di non essere arrivati alla fine 
	li	$t1, 255	# definiamo il valore del modulo 
	li	$t2, 4		# costante di cifratura		
	move	$t3, $s1	# flag di operazione
	
decrip:	beq	$t3, $zero, crip# operazione di decifratura 	 
	li 	$t4, -1		# AGGIUNGERE CONTROLLO SUI NEGATIVI   
	mult	$t2, $t4	#
	mflo	$t2		
	
crip:	add	$t0, $t0, $t2	# operazione di cifratura			
	div	$t0, $t1
	mfhi	$t0  		 		
	sb	$t0, 0($a3)	# salvo il nuovo contenuto da stampare sullo stesso buffer !!!
	
				#  
	add	$a3, $a3,$s2	# 
	j 	convert
	
		
exit:	jr	$ra

	


# PROCEDURA GENERICA DEDICATA ALL'INVERSIONE DI QUALCUASI STRINGA SIA DATA IN PASTO 
# PARAMETRI : $a2 <--- bufferReader , buffer contenente la stringa a invertire 
#	      $a3 <--- buffer di support alla procedura di inversione
	
algD:
	la	$a2, buffer		# Metto il buffer di input in $a2
	la	$a3, support		# Carico il buffer che conterrà il messaggio da restituire in $a3
	move	$t0, $zero			# Inizializzo contatore degli elementi della stringa a 0
	
counterD:					# Metodo che conta quanti elementi sono presenti nel buffer
	lbu	$t1, ($a2)			# Carico il carattere puntato in $t1
	beqz	$t1, endPointer			# Se sono arrivato alla fine della stringa il metodo termina
	addi	$t0, $t0, 1			# Altrimenti aumento il contatore di 1
	addi	$a2, $a2, 1			# Scorro alla posizione successiva del buffer
	
	j 	counterD				# Inizio un nuovo ciclo

endPointer:
	addi	$a2, $a2, -1			# Dato che il il puntatore e' fuori dal buffer, lo faccio tornare						# indietro di una posizione
	move	$s0, $t0			# Dato che e' il numero degli elementi rimarra' invariato lo salvo in $s0
	move	$t0, $zero			# Reinizializzo $t0 per contare il numero di elementi che verranno inseriti

reversal:					# Metodo di inversione				
	beq	$t0, $s0, override		# Se il numero dei caratteri inseriti è pari alla lunghezza del buffer
						# allora posso uscire dalla procedura	
	lbu	$t1, ($a2)			# Altrimenti metto in $t1 l'elemento del buffer di input
	sb	$t1, ($a3)			# e lo salvo nel buffer di uscita

	subi	$a2, $a2, 1			# Vado al carattere precedente del buffer di input
	addi	$a3, $a3, 1			# Scorro alla posizione successiva del buffer di output
	addi	$t0, $t0, 1			# Aumento di 1 il contatore dei caratteri inseriti
	
	j 	reversal
	
override:					# va generalizzata, perche va utilizzato anche nel 'algoritmoE
	la	$a2, buffer
	la	$a3, support
	move	$t0, $zero
	
overrideCicle:
	beq	$t0, $s0, exitInvert
	lbu	$t1, ($a3)
	sb	$t1, ($a2)
	
	addi	$a3, $a3, 1
	addi	$a2, $a2, 1
	addi	$t0, $t0, 1
	
	j	overrideCicle

exitInvert:
	move	$v1, $a2				# Restituisco in $v0 il buffer di output
	jr	$ra	
		
