# GRUPPO DI LAVORO :
# DUCCIO SERAFINI			E-MAIL: duccio.serafini@stud.unifi.it
# ANDRE CRISTHIAN BARRETO DONAYRE	E-MAIL: andre.barreto@stud.unifi.it
# 
# DATA DI CONSEGNA: 
#
#
.data 
# STRINGHE DEDICATE PER LA VISUALIZZAZIONE DELLA OPERAZIONE IN CORSO:
		opCifra:	.asciiz		" Cifratura in corso...\n"
		opDecif:	.asciiz		"\n Decifratura in corso...\n "
		done:		.asciiz 	" \n Operazione Terminata. " 
# DESCRITTORI DEI FILE IN INGRESSO: 
		messaggio:	.asciiz		".marSETUP/messaggio.txt"
		chiave:		.asciiz 	".marSETUP/chiave.txt"
# DESCRITTORI DEI FILE IN USCITA: 


.align 2
# BUFFER DEDICATI ALLA LETTURA DEI DATI DEI FILE IN INPUT:
		bufferReader:	.space	    	255
		bufferKey:	.space	   	 5	
# BUFFER DECICATI AL SUPPORTO DELLE PROCEDURE:
		supportBuffer: 	.space		255
		statusABC:	.space		36
.align 2

.text
.globl main

main:	
		addi	$sp, $sp,-16			# alloco lo spazio per una word nello stack
		sw	$ra, 0($sp)			# salvo nello stack l'indirizzo di ritorno del chiamante
		sw 	$s0, 4($sp)
		sw 	$s1, 8($sp)
		sw 	$s2, 12($sp) 
		
		li	$s7, 0				# inizializo $s7 per usarla come VARIABILE DI STATO
		
		la	$a0, messaggio			# carico il descrittore del file da cifrare
		jal	readMessage			# procedura dedicata a caricare il messaggio da 
	
		
		la	$a0, chiave			# carico il descrittore del file
		jal	readKey				# procedura dedicata alla lettura della chiave
		
		move	$a0, $v0			# passo come parametro il registro di partenza di "bufferkey" 
	
		jal	cifratura			# chiamo la procedura di CIFRATURA 
	
		li	$v0, 4				# DA ELIMINARE al suo posto deve 
		la	$a0, bufferReader		# essereci la procedura che scrive 
		syscall					# in un file di  uscita
		
		# addi	$s7, $s7, 1
		
		# CHIAMA INVERTER PER INVERTIRE LA CHIAVE E METTERLA SU BUFFERKEY
		
		# CHIAMA READFILE SU MESSAGGIOCIFRATO E METTERLO SU BUFFERREADER
		
		#jal 	decrifratura
		
		# chiama la procedura per scrivere in un file di uscita		
		
		j 	exit
	
# MAIN PROCEDURES :VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
#
#
#					
cifratura:	addi	$sp, $sp,-4		# salvo il registro $ra corrente per potere tornare 
		sw	$ra, 0($sp)		# al main a fine alla fine della procedura
		
		move	$t0, $a0		# salvo momentaneamente il valore di $a0, per potere notificare 
						# l'operazione che sta per essere eseguita	

		li	$v0, 4			# messaggio indicativo per indicare la procedura in corso 
		la	$a0, opCifra			
		syscall 
		
		la 	$a0, statusABC
	  	jal 	setStatusABC
	  	
	  		  jal 	setStatusABC	    
	  move $t9, $v0 		# sposto il valore di ritorno   
	  
	  move $t8, $v0 		# sposto il valore di ritorno  
	  
	  li	$t1, 1			# per fermare la stampa  visualizzare lo stato corrente
loop:	  lb	$t0, 0($t9)		#
	  beq	$t1, 10, exit		#
	  				#
	  li 	$v0, 1			#
	  move	$a0, $t0		#
	  syscall			#
	  				#
	  addi 	$t9, $t9, 4		#
	  add	$t1, $t1, 1		#
	  				#
	  j loop			#
	  

	  		    
	  	move 	$a1, $v0 		# passo come parametro l'indirizzo di ritorno all'array degli stati
		move	$a0, $t0		# ripristino il valore fornito dal chiamante
		jal	Core			# chiamata all'operazione core
		
		lw	$ra, 0($sp)		# reimposto il registro $ra iniziale per potere tornare
		addi	$sp, $sp, 4		# al main 
		jr	$ra
		
										
decrifratura:	addi	$sp, $sp,-4		# salvo il registro $ra corrente per potere tornare 
		sw	$ra, 0($sp)		# al main a fine alla fine della procedura

		li	$v0, 4			# messaggio indicativo per indicare la procedura in corso 
		la	$a0, opDecif						
		syscall 			 
		 
		# avvia l'array degli stati aggiornati per ABC
		
		
	
		lw	$ra, 0($sp)		# reimposto il registro $ra iniziale per potere tornare	
		addi	$sp, $sp, 4		# al main 
		jr	$ra
		
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

				
		
# PROCEDURA CHE SCORRE IL BUFFERKEY E PER OGNI SIMBOLO CHIAMA UN ALGORITMO DIVERSO
# PASSANDO GLI OGNI VOLTA BUFFERREADER
# parametri: 		 $a0<--- prende il riferimento a keyBuffer
# 	    		 $a1<--- deve avere il buffer reader				DA AGGIUNGERE 
#
# VALORE DI RITORNO : 	VOID


# DEVE RITORNARE IL REGISTRO DI RIFERIMENTO AD UN BUFFER PER PASSARE AL PROCESSO CHE SCRIVE NEL FILE DI USCITA
 

Core:		addi 	$sp, $sp, -4			# salvo il rigistro di ritorno del chiamante
		sw   	$ra, 0($sp)			# usando lo stack
	
nextAlg:	lb	$t0, ($a0)			# carico il primo carattere della CHIAVE e
		beqz	$t0, exitCore			# controllo se sono arrivato a fine stringa.
		li	$t1, 65				# I varia algoritmi da chiamare vengono riconosciuti   
		sub	$t0, $t0, $t1			# atraverso una operazione di sottrazione  
		slt	$t1, $t0, $zero			# tra il loro valore decimale e la costante 65
		beq	$t1, 1, goNext			#  

		beq	$t0, 0, algorithm_A		
		beq	$t0, 1, algorithm_B
		beq	$t0, 2, algorithm_C
		beq	$t0, 3, algorithm_D
		beq	$t0, 4, algorithm_E


algorithm_A:						# chiama Shifter
		addi 	$sp, $sp, -8
		sw   	$a0, 0($sp)			# salvo l'indirezzo di partenza della chiave
		sw	$a1, 4($sp)
		
		
		jal	shifter
	
		lw	$a1, 4($sp)
		lw	$a0, 0($sp)
		addi	$sp, $sp, 8
		j	goNext

	
algorithm_B:						# chiama Shifter
		addi 	$sp, $sp, -4
		sw   	$a0, 0($sp)
	
		
		jal	shifter
	
		lw	$a0, 0($sp)
		addi	$sp, $sp, 4
	
		j	goNext
	
algorithm_C:						# chiama Shifter
		addi 	$sp, $sp, -4
		sw   	$a0, 0($sp)
	

		
		jal	shifter
	
		lw	$a0, 0($sp)
		addi	$sp, $sp, 4
		j	goNext
	
algorithm_D:						# chiama Inverter
		addi 	$sp, $sp, -4
		sw   	$a0, 0($sp)

		
		jal	algD


		lw	$a0, 0($sp)
		addi	$sp, $sp, 4
		j	goNext
	
algorithm_E:						# chiama occurenceCounter
		addi 	$sp, $sp, -4
		sw   	$a0, 0($sp)
	
		
		lw	$a0, 0($sp)
		addi	$sp, $sp, 4
		j	goNext			

goNext:		addi	$a0, $a0, 1			# aggiorna il registro di 1 per chiamare  
		j	nextAlg				# l'algoritmo successivo
					
exitCore:	lw	$ra, 0($sp)			# reimposto il registro $ra iniziale per potere tornare	
		addi	$sp, $sp, 4
		jr	$ra
		
# setStatusABC setta l'array degli stati dedicati alle procedure ABC
# ofsetper leggere lo stato : 0 è A , 12 è B,  24 è C
# 	

setStatusABC:	addi 	$sp, $sp, -4
		sw 	$ra, 0($sp)
	
		move $t9, $a0
	
		jal algAStatus
	
		addi $a0, $a0, 12
		jal algBStatus
	
		addi $a0, $a0, 12
		jal algCStatus
	
		move $v0, $t9
	
		lw	$ra, 0($sp)
		addi	$sp, $sp, 4	
		jr 	$ra		
		
		
		
		
		
# ALGORITMO A- STATUS:  PROCEDURA DEDICATA AL SETTAGGIO DEI FLAG DEDICATI ALL'ALGORITMO A 		
algAStatus:	addi 	$sp, $sp, -4
		sw 	$ra, 0($sp)

		move	$t1, $a0 # sposto il riferimento al buffer degli stati per poterlo trattare meglio
		li	$s0, 0
		li	$s2, 1
		sb	$s0, 0($t1)	# carico l'indirizzo di partenza $s0
		sb	$s2, 8($t1)	# carico il passo di lettura $s2
		
		beqz 	$s7, CifraturaA
		li	$s1, 1
		sb	$s1, 4($t1)	# carico $s1 che specifica l'operazione da eseguire		
		j	DecifraturaA

CifraturaA:	li	$s1, 0
		sb	$s1, 4($t1)	# carico $s1 che specifica l'operazione da eseguire

DecifraturaA:	lw	$ra, 0($sp)
		addi	$sp, $sp, 4
		jr $ra

# ALGORITMO B- STATUS:  PROCEDURA DEDICATA AL SETTAGGIO DEI FLAG DEDICATI ALL'ALGORITMO B 				
algBStatus:	addi 	$sp, $sp, -4
		sw 	$ra, 0($sp)
		
		move	$t1, $a0
		li	$s0, 0
		li	$s2, 2
		sb	$s0, 0($t1)	# carico l'indirizzo di partenza $s0
		sb	$s2, 8($t1)	# carico il passo di lettura $s2
		
		beqz 	$s7, CifraturaB
		li	$s1, 1
		sb	$s1, 4($t1)	# carico $s1 che specifica l'operazione da eseguire			
		j	DecifraturaB

CifraturaB:	li	$s1, 0
		sb	$s1, 4($t1)

DecifraturaB:	lw	$ra, 0($sp)
		addi	$sp, $sp, 4
		jr 	$ra

# ALGORITMO C- STATUS:  PROCEDURA DEDICATA AL SETTAGGIO DEI FLAG DEDICATI ALL'ALGORITMO C		
algCStatus:	addi 	$sp, $sp, -4
		sw 	$ra, 0($sp)
		
		move	$t1, $a0
		li	$s0, 1
		li	$s2, 2
		sb	$s0, 0($t1)	# carico l'indirizzo di partenza $s0
		sb	$s2, 8($t1)	# carico il passo di lettura $s2
		
		beqz 	$s7, CifraturaC
		li	$s1, 1
		sb	$s1, 4($t1)	# carico $s1 che specifica l'operazione da eseguire				
		j	DecifraturaC

CifraturaC:	li	$s1, 0	
		sb	$s1, 4($t1)
		
DecifraturaC:	lw	$ra, 0($sp)
		addi	$sp, $sp, 4
		jr 	$ra

# READ-MESSAGE - PROCEDURA DEDICATA ALLA LETTURA DEL FILE DI TESTO DA CRIFRARE O DECIFRARE 
# PARAMETRI : 		$a0<--DESCRITTORE DEL FILE 
#
# VALORE DI RITORNO :	$v0<--REGISTRO DEL BUFFER CON I DATI LETTI 
readMessage:	addi 	$sp, $sp, -4
		sw   	$ra, 0($sp)		# salvo il rigistro di ritorno del chiamante 
		
		jal 	openFile		# apro il file in solo lettura
		move	$a0, $v0		# passo il descrittore del file alla prossima procedura
		
		la	$a1, bufferReader	# buffer che conterra il messaggio corrente 
		li	$a2, 255		# dimensione del buffer
		jal	readFile		# leggo il file e carico il buffer dedicato
		
		move	$v0, $a1		# sposto il valore di ritorno nel registro dedicato
	
		lw	$ra, 0($sp)		# reimposto il registro del chiamante
		addi	$sp, $sp, 4
		jr 	$ra

	  
# READ-KEY - PROCEDURA DEDICATA ALLA LETTURA DELLE CHIAVI DI CIFRATURA CORRENTE
# PARAMETRI : 		$a0<--DESCRITTORE DEL FILE 
#
# VALORE DI RITORNO :	$v0<--REGISTRO DEL BUFFER CON I DATI LETTI 
readKey:	addi 	$sp, $sp, -4
		sw   	$ra, 0($sp)		# salvo il rigistro di ritorno del chiamante 

		jal 	openFile		# apro il file in solo lettura
		move	$a0, $v0		# passo il descrittore del file alla prossima procedura
		
		la	$a1, bufferKey		# buffer che conterra la chiave corrente 
		li	$a2, 5			# dimensione del buffer
		jal	readFile		# leggo il file e carico il buffer dedicato
		
		move	$v0, $a1		# sposto il valore di ritorno nel registro dedicato
	
		lw	$ra, 0($sp)		# reimposto il registro del chiamante
		addi	$sp, $sp, 4
		jr 	$ra	



# OPEN-FILE: PROCEDURA CHE PERMETTE DI APRILE UN FILE IN SOLO LETTURA
# PARAMETRI : 		$a0<--DESCRITTORE DEL FILE 
#
# VALORE DI RITORNO :	$v0<--REGISTRO DEL BUFFER CON I DATI LETTI 
openFile:	
		li	$v0, 13
		li	$a1, 0
		li	$a2, 0
		
		syscall
		jr $ra
	

# READ-FILE: PROCEDURA PER LEGGERE IL CONTENUTO DEL FILE
# PARAMETRI:		$a0<-- DESCRITTORE DEL FILE 
#			$a1<-- REGISTRO CHE CONTIENE L'INDIRIZZO DI PARTENZA DEL BUFFER DI RIFERIMENTO  
#			$a2<-- GRANDEZZA DEL BUFFER DI RIFERIMENTO 
#
# VALORE DI RITORNO:	$v0<--REGISTRO DEL BUFFER CON I DATI LETTI  
readFile:
		li 	$v0, 14
		
		syscall
		jr $ra

# PROCEDURA GENERICA CHE SVOLGERA IL CIFRATURA E LA DECIFRATURA DEGLI ALGORITMI A - B - C 
# IL SUO COMPORTAMENTO E' DEFINITO DA PROCEDURE DEDICATE CHE SETTANO DEI FLAG AD OGNI CHIAMATA
# PARAMETRI:		$s0 <--  offset di inizio di scorrimento del buffer
#			$s1 <--  flag distinzione tra operazione di CRIFRATURA e DECIFRATURA
#			$s2 <--	 offset dedicato al passo di scorrimento del buffer
#
# VALORE DI RITORNO:	VOID

shifter:	
		la	$a3, bufferReader	# salvo il puntatore al buffer CARICA QUI IL RIFERIMENTO AL BUFFER DEGLI STATI
		move	$s6, $a0	# sposto il riferimento al buffer degli stati 
		lb	$s0, 0($s6) 	
		add	$a3, $a3, $s0 	# definiamo l'indice di partenza $s0	
								
convertitore:	lb	$t0, ($a3) 	# $t0 carichiamo la lettera da cifrare
		beqz    $t0, uscitaShifter	# controlliamo di non essere arrivati alla fine 
		li	$t1, 255	# definiamo il valore del modulo 
		li	$t2, 4		# costante di cifratura	
		lb	$t3, 4($s6)	# carico il flag di operazione		$s1
	
decriptazione:	beqz	$t3, criptazione	# operazione di decifratura 	 
		li 	$t4, -1		# AGGIUNGERE CONTROLLO SUI NEGATIVI   
		mult	$t2, $t4	#
		mflo	$t2		
	
criptazione:	add	$t0, $t0, $t2	# operazione di cifratura			
		div	$t0, $t1
		mfhi	$t0  		 		
		sb	$t0, 0($a3)	# salvo il nuovo contenuto da stampare sullo stesso buffer !!!
	
		lb	$s2, 8($s6)	# carico il passo   
		add	$a3, $a3,$s2	# definito in $s2	
		j 	convertitore
		
uscitaShifter:	move 	$v0, $a3
		jr	$ra

			
# PROCEDURA GENERICA DEDICATA ALL'INVERSIONE DI QUALCUASI STRINGA SIA DATA IN PASTO 
# PARAMETRI : 		$a2 <--bufferReader , buffer contenente la stringa a invertire 
#	     		$a3 <--buffer di support alla procedura di inversione
#
# VALORE DI RITORNO:	VOID
algD:	la	$a2, bufferReader		# Metto il buffer di input in $a2
	la	$a3, supportBuffer		# Carico il buffer che conterr� il messaggio da restituire in $a3

	move	$t0, $zero			# Inizializzo contatore degli elementi della stringa a 0
	
counterD:					# Metodo che conta quanti elementi sono presenti nel buffer
	lbu	$t1, ($a2)			# Carico il carattere puntato in $t1
	beqz	$t1, endPointer			# Se sono arrivato alla fine della stringa il metodo termina
	addi	$t0, $t0, 1			# Altrimenti aumento il contatore di 1
	addi	$a2, $a2, 1			# Scorro alla posizione successiva del buffer
	
	j 	counterD				# Inizio un nuovo ciclo

endPointer:

	addi	$a2, $a2, -1			# Dato che il il puntatore e' fuori dal buffer, lo faccio tornare
						# indietro di una posizione
	move	$s0, $t0				# Dato che e' il numero degli elementi rimarra' invariato lo salvo in $s0
	move	$t0, $zero			# Reinizializzo $t0 per contare il numero di elementi che verranno inseriti

reversal:					# Metodo di inversione				
	beq	$t0, $s0, override		# Se il numero dei caratteri inseriti � pari alla lunghezza del buffer

						# allora posso uscire dalla procedura	
	lbu	$t1, ($a2)			# Altrimenti metto in $t1 l'elemento del buffer di input
	sb	$t1, ($a3)			# e lo salvo nel buffer di uscita
	
	li	$t9, 1				# perche ad qtspim non piace subi
	sub	$a2, $a2, $t9			# Vado al carattere precedente del buffer di input
	add	$a3, $a3, $t9			# Scorro alla posizione successiva del buffer di output
	add	$t0, $t0, $t9			# Aumento di 1 il contatore dei caratteri inseriti
	
	j 	reversal

override:
	la	$a2, bufferReader
	la	$a3, supportBuffer
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
	
# fine del programma
		
exit:
	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s1, 8($sp)
	lw 	$s2, 12($sp)
	addi 	$sp, $sp, 16
	
	li	$v0, 4				
	la	$a0, done				# visualizza il messaggio di terminazione del programma							
	syscall				
	
	li $v0,10
	syscall
