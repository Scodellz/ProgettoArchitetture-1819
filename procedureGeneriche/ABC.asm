.data
	buffer: 	.asciiz	"Prova"

.align 2
.text

main:
	li	$a1, 0
	jal	A
	
	
	li	$a1, 0
	jal	B

	
	li	$a1, 0
	jal	C
	
	li	$v0, 4
	la	$a0, buffer
	syscall
	
	li	$a1, 1
	jal	C
	
	li	$a1, 1
	jal	B
	
	li	$a1, 1
	jal	A

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
		 
	la	$a3, buffer	# salvo il puntatore al buffer
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


		
			
					
		
