# GRUPPO DI LAVORO :
# DUCCIO SERAFINI			E-MAIL: duccio.serafini@stud.unifi.it
# ANDRE CRISTHIAN BARRETO DONAYRE	E-MAIL: andre.barreto@stud.unifi.it
# 
# DATA DI CONSEGNA: 
#
#
.data 
# STRINGHE DEDICATE PER LA VISUALIZZAZIONE DELLA OPERAZIONE IN CORSO:
	opCifra:	.asciiz		" cifratura in corso...\n"
	opDecif:	.asciiz		"\n decifratura in corso...\n "
	done:		.asciiz 	" \n operazione terminata. " 
# DESCRITTORI DEI FILE IN INGRESSO: 
	messaggio:	.asciiz		".marSETUP/messaggio.txt"
	chiave:		.asciiz 	".marSETUP/chiave.txt"
# DESCRITTORI DEI FILE IN USCITA: 


.align 2
# BUFFER DEDICATI ALLA LETTURA DEI DATI DEI FILE IN INPUT:
	bufferReader:	.space	    	255
	bufferKey:	.space	    5	
# 	

.align 2

.text
.globl main

main:	
	addi	$sp, $sp,-16		# alloco lo spazio per una word nello stack
	sw	$ra, 0($sp)		# salvo nello stack l'indirizzo di ritorno del chiamante
	sw 	$s0, 4($sp)
	sw 	$s1, 8($sp)
	sw 	$s2, 12($sp) 

	jal	cifratura
	
	li	$v0, 4
	la	$a0, bufferReader
	syscall
	
	#jal 	decrifratura	
		
	j 	exit
	
# MAIN PROCEDURES					
cifratura:	addi	$sp, $sp,-4		# alloco lo spazio per una word nello stack
		sw	$ra, 0($sp)

		li	$v0, 4			# eseguiamo le procedure di decifraturaaggio
		la	$a0, opCifra			
		syscall 
		
		la	$a0, messaggio		# carico il descrittore del file
		jal	leggiMessaggio
		move 	$s7,$v0			# sposto il registro di riferimento che contiene il messaggio appena letto
	
		la	$a0, chiave		# carico il descrittore del file
		jal	leggiChiave
		
		move	$a0, $v0		# passo come parametro il registro al bufferkey 
		move	$a1, $s7		# passo come parametro il registro al bufferReader
		jal	Core
		
		lw	$ra, 0($sp)
		addi	$sp, $sp, 4
		jr	$ra
		
										
decrifratura:	addi	$sp, $sp,-4		# alloco lo spazio per una word nello stack
		sw	$ra, 0($sp)

		li	$v0, 4			# 
		la	$a0, opDecif		# 				
		syscall 			# 
		 
		
	
		lw	$ra, 0($sp)
		addi	$sp, $sp, 4
		jr	$ra
		
		
# PROCEDURA CHE SCORRE IL BUFFERKEY E PER OGNI SIMBOLO CHIAMA UN ALGORITMO DIVERSO
# PASSANDO GLI OGNI VOLTA BUFFERREADER
# parametri: $a0<--- prende il riferimento a keyBuffer
# 	     $a1<--- deve avere il buffer reader	DA AGGIUNGERE 
#
# DEVE RITORNARE IL REGISTRO DI RIFERIMENTO AD UN BUFFER PER PASSARE AL PROCESSO CHE SCRIVE NEL FILE DI USCITA
# 
Core:
	addi 	$sp, $sp, -4
	sw   	$ra, 0($sp)		# salvo il rigistro di ritorno del chiamante
	
opCore:	lb	$t0, ($a0)		# carico il primo carattere della chiave
	beqz	$t0, exitCore
	li	$t1, 65
	sub	$t0, $t0, $t1
	slt	$t1, $t0, $zero
	beq	$t1, 1, goNext

	beq	$t0, 0, callProcedureA		
	beq	$t0, 1, callProcedureB
	beq	$t0, 2, callProcedureC
	beq	$t0, 3, callProcedureD
	beq	$t0, 4, callProcedureE
	 
callProcedureA:
	addi 	$sp, $sp, -4
	sw   	$a0, 0($sp)
	
	# questa parte va generalizzata
	li	$s0, 0			
	li	$s1, 0		# questo va letto dell'esterno:  0 - cripta | 1- decifra
	li	$s2, 1
	jal	shifter
	
	lw	$a0, 0($sp)
	addi	$sp, $sp, 4
	
	j	goNext
	
callProcedureB:	
	addi 	$sp, $sp, -4
	sw   	$a0, 0($sp)
	
	# questa parte va generalizzata
	li	$s0, 0
	li	$s1, 0		# questo va letto dell'esterno:  0 - cripta | 1- decifra
	li	$s2, 2
	jal	shifter
	
	lw	$a0, 0($sp)
	addi	$sp, $sp, 4
	
	j	goNext
	
callProcedureC:	
	addi 	$sp, $sp, -4
	sw   	$a0, 0($sp)
	
	# questa parte va generalizzata
	li	$s0, 1
	li	$s1, 0		# questo va letto dall'esterno:  0 - cripta | 1- decifra
	li	$s2, 2
	jal	shifter
	
	lw	$a0, 0($sp)
	addi	$sp, $sp, 4
	j	goNext
	
callProcedureD:
	addi 	$sp, $sp, -4
	sw   	$a0, 0($sp)
		
		
	lw	$a0, 0($sp)
	addi	$sp, $sp, 4
	
	j	goNext
	
callProcedureE:
	addi 	$sp, $sp, -4
	sw   	$a0, 0($sp)
	
		
	lw	$a0, 0($sp)
	addi	$sp, $sp, 4
	
	j	goNext			

goNext:	addi	$a0, $a0, 1	
	j	opCore	
					
exitCore:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
	  
# PROCEDURA DEDICATA ALLA LETTURA DELLE CHIAVI SIA IN FASE DI CRIPTAGGIO CHE DECRIPTAGGIO (IN CUI PRIMA DI SCRIVERLA LA DEVE INVERTIRE ) 
# valore di ritorno, il registro del buffer pieno è in $v0
# PAREMETRI: $a0 il riferimento a file contenente la chiave
leggiChiave:
	addi 	$sp, $sp, -4
	sw   	$ra, 0($sp)		# salvo il rigistro di ritorno del chiamante 
	
	jal 	openFile		# apro il file in solo lettura
	
	move	$a0, $v0		# passo il descrittore del file alla prossima procedura
	la	$a1, bufferKey
	li	$a2, 5
	jal	readFile
	move	$v0, $a1		# sposto nel registro per i valori di ritorno, il riferimento al bufferKey PIENO
	
	lw	$ra, 0($sp)		# ripristino l'indirizzo del chiamante originale
	addi	$sp, $sp, 4
	
	jr 	$ra	
	

# PROCEDURA DEDICATA ALLA LETTURA DEL FILE DI TESTO DA CRIFRARE O DECIFRARE 
# PARAMETRI 		$a0<---- DESCRITTORE DEL FILE 
# VALORE DI RITORNO :	$v0 ---> REGISTRO DEL BUFFER CON I DATI LETTI 
leggiMessaggio:
	addi 	$sp, $sp, -4
	sw   	$ra, 0($sp)		# salvo il rigistro di ritorno del chiamante 
		
	jal 	openFile		# apro il file in solo lettura
	move	$a0, $v0		# passo il descrittore del file alla prossima procedura
	la	$a1, bufferReader
	li	$a2, 255
	jal	readFile
	move	$v0, $a1		# sposto nel registro per i valori di ritorno, il riferimento al bufferReader PIENO
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	
	jr 	$ra


# PROCEDURA CHE PERMETTE DI APRILE UN FILE IN SOLO LETTURA
# parametri : $a0 <--- descrittore del file 
# ritorno :  $v0 ----> ritorna il percorso del file
openFile:	
	li	$v0, 13
	li	$a1, 0
	li	$a2, 0
	syscall
	jr $ra
	
# PROCEDURA PER LEGGERE IL CONTENUTO DEL FILE
# parametri	$a0 <- descrittore del file, aperto precedentemente in LETTURA
#		$a1 <- bufferReader, il riferimento al buffer in cui andra a scrivere il contenuto del file
#		$a2 <- grandezza del buffer di riferimento 
# ritorno 	$v0 -> ritorna il buffer con i dati 
readFile:
	li 	$v0, 14
	syscall
	jr $ra
		
## PROCEDURA PER VISUALIZZARE IL CONTENUTO DI QUALSIASI BUFFER  ************************ DA TOGLIERE SOLO ALLA FINE 
# parametri $a0 <- vuole il buffer da visualizzare 
printContent:
	li	$v0, 4
	syscall
	jr	$ra


# PROCEDURA GENERICA CHE SVOLGERA IL CIFRATURA E LA DECIFRATURA DEGLI ALGORITMI A - B - C 
# : il suo confortamento sarà definito dal settaggio di alcuni flag, da procedure dedicate 
#  parametri :
#	$s0 <--  offset di inizio di scorrimento del buffer
#	$s1 <--  flag distinzione tra operazione di CRIFRATURA e DECIFRATURA
#	$s2 <--	 offset dedicato al passo di scorrimento del buffer
# viene utilizzato il solito buffer

shifter:	
		 
	la	$a3, bufferReader	# salvo il puntatore al buffer
	add	$a3, $a3, $s0 		# definiamo l'indice di partenza	
								
convert:lb	$t0, ($a3) 		# $t0 carichiamo la lettera da cifrare
	beqz	$t0, exitShifter	# controlliamo di non essere arrivati alla fine 
	li	$t1, 255		# definiamo il valore del modulo 
	li	$t2, 4			# costante di cifratura		
	move	$t3, $s1		# flag di operazione
	
decrip:	beqz	$t3, crip	# operazione di decifratura 	 
	li 	$t4, -1			# AGGIUNGERE CONTROLLO SUI NEGATIVI   
	mult	$t2, $t4		#
	mflo	$t2		
	
crip:	add	$t0, $t0, $t2		# operazione di cifratura			
	div	$t0, $t1
	mfhi	$t0  		 		
	sb	$t0, 0($a3)		# salvo il nuovo contenuto da stampare sullo stesso buffer !!!
	
					#  
	add	$a3, $a3,$s2		# somma del passo di scorrimento
	j 	convert	
	
exitShifter:
	jr	$ra 	
	
# fine del programma
		
exit:
	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s1, 8($sp)
	lw 	$s2, 12($sp)
	addi 	$sp, $sp, 16
	
	li	$v0, 4				
	la	$a0, done			# visualizza il messaggio di terminazione del programma							
	syscall				
	
	li $v0,10
	syscall
		
	# jr $ra 				# forse si toglie, forse no, da chiedere a chiara
		
