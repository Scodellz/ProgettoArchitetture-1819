# GRUPPO DI LAVORO :
# DUCCIO SERAFINI			E-MAIL: duccio.serafini@stud.unifi.it
# ANDRE CRISTHIAN BARRETO DONAYRE	E-MAIL: andre.barreto@stud.unifi.it
# 
# DATA DI CONSEGNA: 
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
						# messaggioCifrato	
						# messaggioDecifrato
.align 2
# BUFFER DEDICATI ALLA LETTURA DEI DATI DEI FILE IN INPUT:
		bufferReader:	.space	    	255
		bufferKey:	.space	   	 5	
# BUFFER DECICATI AL SUPPORTO DELLE PROCEDURE:
		supportBuffer: 	.space		255
		statusABC:	.space		36
		supportInvert: 	.space		5		# qtspim rompe il cazzo, va riguardo ma in generale torna	
		space:		.asciiz 	"\n"
.align 2

.text
.globl main

main:	
		addi	$sp, $sp,-16			# alloco lo spazio per una word nello stack
		sw	$ra, 0($sp)			# salvo nello stack l'indirizzo di ritorno del chiamante
		sw 	$s0, 4($sp)
		sw 	$s1, 8($sp)
		sw 	$s2, 12($sp) 
		
		
		la	$a0, messaggio 			# la chiamata a queste procedure mi permettono di caricare
		jal	readMessage			# i buffer interessati
		
		# metti qui poi una stampa di messaggio
		
		la	$a0,chiave
		jal	readKey			
			
		li	$s7, 0				# inizializo $s7 per usarla come VARIABILE DI STATO							
		
		jal	cifratura			# chiamo la procedura di CIFRATURA 
	
		# metti qui la stama del messaggio 
		
		# addi	$s7, $s7, 1			# avvio fase decifratura 
		
		# la	$a0,chiave
		# jal	readKey	
		
		# la 	$a0,messaggioDecifrato
		# jal	readMessage		
		
		 #jal 	decrifratura
		
		# scrivi su file di uscita		
		
		j 	exit


# MAIN PROCEDURES :VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV					
cifratura:	addi	$sp, $sp,-4			# salvo il registro $ra corrente per potere tornare 
		sw	$ra, 0($sp)			# al main a fine alla fine della procedura
		
		li	$v0, 4				# messaggio indicativo per indicare la procedura in corso 
		la	$a0, opCifra			
		syscall 
		
		la	$a0, statusABC 
		jal	setStatusABC			# sia statusABC, sia $t9 mi puntano allo stesso array pieno degli stati
		
		    
	  	move $t9, $v0 				# sposto il valore di ritorno   
	  	
		la	$a0, bufferKey
		la	$a1, bufferReader
		la	$a2, statusABC	
		# riferimento agli stati 
		jal	core			
		
		li	$v0, 4
		move	$a0, $a1
		syscall

		
uscita:		lw	$ra, 0($sp)			# reimposto il registro $ra iniziale per potere tornare
		addi	$sp, $sp, 4			# al main 
		jr	$ra
		
# -----------------------------------------------------------------------------------------------------------------------
decrifratura:	addi	$sp, $sp,-4			# salvo il registro $ra corrente per potere tornare 
		sw	$ra, 0($sp)			# al main a fine alla fine della procedura

		li	$v0, 4				# messaggio indicativo per indicare la procedura in corso 
		la	$a0, opDecif						
		syscall 			 
		 
		la	$a0, statusABC 
		jal	setStatusABC
		move 	$t9, $v0			# recupero il vaore di ritorno 


		lw	$ra, 0($sp)			# reimposto il registro $ra iniziale per potere tornare	
		addi	$sp, $sp, 4			# al main 
		jr	$ra
									
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

# PROCEDURA CHE SCORRE IL BUFFERKEY E PER OGNI SIMBOLO CHIAMA UN ALGORITMO DIVERSO PASSANDOLI OGNI VOLTA BUFFERREADER
# 
# 
# DEVE RITORNARE IL REGISTRO DI RIFERIMENTO AD UN BUFFER PER PASSARE AL PROCESSO CHE SCRIVE NEL FILE DI USCITA

core:		addi 	$sp, $sp, -4			# INIZIO CORE
		sw 	$ra, 0($sp)				# salvo il registro di ritorno 
		
		move	$s6, $a0			# bufferKey copia del registro di partenza che contiene le chiavi
		move	$s5, $a1			# bufferReader copia del registro di partenza che contiene le chiavi
		move	$s4, $a2			# statusABC copia del registro di partenza che contiene gli stati
		
		
nextAlg:	lb	$t0, ($s6)			# carico il primo simbolo delle chiavi 
		beqz	$t0, exitCore			# controllo se sono arrivato a fine stringa.
		li	$t1, 65				# I varia algoritmi da chiamare vengono riconosciuti   
		sub	$t0, $t0, $t1			# atraverso una operazione di sottrazione con 65  
		slt	$t1, $t0, $zero			# 
		beq	$t1, 1, goNext			#  
		
		beq	$t0, 0, algorithm_A		
		beq	$t0, 3, algorithm_D

algorithm_A:	
		addi 	$sp, $sp, -16	
		sw 	$s6, 0($sp)
		sw 	$s5, 4($sp)
		sw 	$s4, 8($sp)
		sw	$t0, 12($sp)
		sw	$ra, 16($sp)
		
		move	$a0, $s4			# passo il registro di inzio degli stati 
		jal	shifter
		
		lw	$ra, 16($sp)
		lw	$t0, 12($sp)
		lw	$s4, 8($sp)
		lw	$s5, 4($sp)
		lw	$s6, 0($sp)
		addi	$sp, $sp, 16
		
		j	goNext
algorithm_D:
		addi 	$sp, $sp, -16	
		sw 	$s6, 0($sp)
		sw 	$s5, 4($sp)
		sw 	$s4, 8($sp)
		sw	$t0, 12($sp)
		sw	$ra, 16($sp)
		
		la 	$a2, bufferReader
		la	$a3, supportBuffer
		jal	algD
		
		lw	$ra, 16($sp)
		lw	$t0, 12($sp)
		lw	$s4, 8($sp)
		lw	$s5, 4($sp)
		lw	$s6, 0($sp)
		addi	$sp, $sp, 16

		j	goNext
		
goNext:		addi	$s6, $s6, 1			# aggiorna il registro di 1 per chiamare  
		j	nextAlg				# l'algoritmo successivo

exitCore:	lw	$ra, 0($sp)			# reimposto il registro $ra iniziale per potere tornare	
		addi	$sp, $sp, 4
		jr	$ra				# FINE CORE
		

# PROCEDURA GENERICA CHE SVOLGERA IL CIFRATURA E LA DECIFRATURA DEGLI ALGORITMI A - B - C 
# IL SUO COMPORTAMENTO E' DEFINITO DA PROCEDURE DEDICATE CHE SETTANO DEI FLAG AD OGNI CHIAMATA
# PARAMETRI:		$s0 <--  offset di inizio di scorrimento del buffer
#			$s1 <--  flag distinzione tra operazione di CRIFRATURA e DECIFRATURA
#			$s2 <--	 offset dedicato al passo di scorrimento del buffer
#
# VALORE DI RITORNO:	VOID

shifter:	addi	$sp, $sp,-4			# salvo il registro $ra corrente per potere tornare 
		sw	$ra, 0($sp)
		
		la	$a3, bufferReader		# carico il buffer di lavoro 
		move	$s6, $a0			# riprendo l'indirizzo di partenza de array degli stati 

		lb	$s0, 0($s6) 			# $s0: definiamo l'indice di partenza 
		add	$a3, $a3, $s0 				
								
convertitore:	lb	$t0, 0($a3) 			# $t0 carichiamo la lettera da cifrare
		beqz    $t0, uscitaShifter		# controlliamo di non essere arrivati alla fine 
		li	$t1, 255			# definiamo il valore del modulo 
		li	$t2, 4				# costante di cifratura	
		lb	$t3, 4($s6)			# $s1 : carico il flag di operazione		
	
decriptazione:	beqz	$t3, criptazione		# discrimiante delle operazioni di cifratura o decifratura 
		li 	$t4, -1				# AGGIUNGERE CONTROLLO SUI NEGATIVI   
		mult	$t2, $t4			#
		mflo	$t2		
	
criptazione:	add	$t0, $t0, $t2			# operazione di cifratura			
		div	$t0, $t1
		mfhi	$t0  		 		
		sb	$t0, 0($a3)			# salvo il nuovo contenuto da stampare sullo stesso buffer !!!
	
		lb	$s2, 8($s6)			# $s2: carico il passo per la lettura del successivo   
		add	$a3, $a3, $s2			
		j 	convertitore
		
uscitaShifter:	move 	$v0, $a3
		lw	$ra, 0($sp)			# reimposto il registro $ra iniziale per potere tornare	
		
		addi	$sp, $sp, 4			# al main 
		jr	$ra				# fine SHIfTER



# PROCEDURA GENERICA DEDICATA ALL'INVERSIONE DI QUALCUASI STRINGA SIA DATA IN PASTO 
# PARAMETRI : $a2 <--- bufferReader , buffer contenente la stringa a invertire 
#	      $a3 <--- buffer di support alla procedura di inversione
	
algD:		add	$sp, $sp, -4
		sw	$ra, 0($sp)
		
		move	$t9, $a2 			# bufferReader 
		move	$t8, $a3			# support buffer
		
		move	$t0, $zero			# Inizializzo contatore degli elementi della stringa a 0
		jal	bufferLenght
	
reversal:						# Ciclo di inversione:				
		beq	$t0, $s0, swapVet		# Se il numero dei caratteri inseriti è pari alla lunghezza del buffer
							# allora posso uscire dalla procedura	
		lbu	$t1, ($a2)			# Altrimenti metto in $t1 l'elemento del buffer di input
		sb	$t1, ($a3)			# e lo salvo nel buffer di uscita
		
		li	$t5, 1
		sub	$a2, $a2, $t5			# Vado al carattere precedente del buffer di input
		addi	$a3, $a3, 1			# Scorro alla posizione successiva del buffer di output
		addi	$t0, $t0, 1			# Aumento di 1 il contatore dei caratteri inseriti
	
		j 	reversal
	
	
swapVet: 	move	$a3, $t8			# $a3 : vettore che con i dati partenza 	
		move	$a2, $t9			# $a2 : sovrascrivo il contenuto di bufferReader 							
		jal	overWrite
	
		move	$v0, $v1			# riporto in uscita il vettore aggiornato
	
		lw	$ra, 0($sp)
		add	$sp, $sp, 4
		
		jr	$ra				# fine algoritmo D
	
# procedura dedicata all'algoritmo D conta la lunghezza dell'array
#
#
bufferLenght:	add	$sp, $sp, -4
		sw	$ra, 0($sp)					# Metodo che conta quanti elementi sono presenti nel buffer
	
counterLoop:	lbu	$t1, ($a2)			# Carico il carattere puntato in $t1
		beqz	$t1, exit_loopCounter			# Se sono arrivato alla fine della stringa il metodo termina
		addi	$t0, $t0, 1			# Altrimenti aumento il contatore di 1
		addi	$a2, $a2, 1			# Scorro alla posizione successiva del buffer
		j 	counterLoop				# Inizio un nuovo ciclo

exit_loopCounter:
		addi	$a2, $a2, -1			# Dato che il il puntatore e' fuori dal buffer, lo faccio tornare						# indietro di una posizione
		move	$s0, $t0			# Dato che e' il numero degli elementi rimarra' invariato lo salvo in $s0
		move	$t0, $zero			# Reinizializzo $t0 per contare il numero di elementi che verranno inseriti
		
		lw	$ra, 0($sp)
		add	$sp, $sp, 4
		jr 	$ra
		
# procedura che sovrascrive il contenuto di qualasiasi vettore 
#	parametri 	$a3 : vettore che con i dati partenza 	
# 			$a2 : vettore di arrivo

overWrite:	add	$sp, $sp, -4
		sw	$ra, 0($sp)
		
		move	$t0, $zero
	
loop_overWrite:
		beq	$t0, $s0, exit_loopOW
		lbu	$t1, ($a3)
		sb	$t1, ($a2)
	
		addi	$a3, $a3, 1
		addi	$a2, $a2, 1
		addi	$t0, $t0, 1
	
		j	loop_overWrite

exit_loopOW:	move	$v1, $a2				# Restituisco in $v0 il buffer di output

		lw	$ra, 0($sp)
		add	$sp, $sp, 4
		jr 	$ra
		
		
# readMessage : procedura dedicata a leggere il file che deve essere CIFRATO o DECIFRATO
# parametri : 		$a0 : descritttore del file da leggere (l'etticheta che conitiene il percorso) 
#
# valore di ritorno: 	void 
# il suo effetto è quello di riempire il file da trattare 	
readMessage:	addi 	$sp, $sp, -4
		sw	$ra, 0($sp)		# salvo il registro di ritorno del chiamante
		
		jal	openFile		#  apre il file in solo lettura,il descrittore lo riceve dal main 		
		
		move	$a0, $v0	 	# passo il descrittore del file 
		la	$a1, bufferReader	# buffer che conterra il messaggio corrente 
		li	$a2, 255		# dimensione del buffer
		jal	readFile		# leggo il file e carico il buffer dedicato
			 		
		lw	$ra, 0($sp)		# reimposto il registro del chiamante
		addi	$sp, $sp, 4
		jr $ra

# readKey: procedura dedicata a leggere il file che contiene la CHIAVE di cifratura corrente
# PARAMETRI : 		$a0<--DESCRITTORE DEL FILE 
#
# valore di ritorno: 	void 
# il suo effetto è quello di riempire il file da trattare 
readKey:	addi 	$sp, $sp, -4
		sw   	$ra, 0($sp)		# salvo il rigistro di ritorno del chiamante 

		jal 	openFile		# apro il file in solo lettura
		move	$a0, $v0		# passo il descrittore del file alla prossima procedura
		
		la	$a1, bufferKey		# buffer che conterra la chiave corrente 
		li	$a2, 5			# dimensione del buffer
		jal	readFile		# leggo il file e carico il buffer dedicato
		
		beqz	$s7, readKey_Exit	# per la decifratura
		la	$a2, bufferKey		# Metto il buffer di input in $a2
		la	$a3, supportInvert	# Carico il buffer che conterrà il messaggio da restituire in $a3
		jal 	algD
	 
						
readKey_Exit:	lw	$ra, 0($sp)		# reimposto il registro del chiamante
		addi	$sp, $sp, 4
		jr $ra	

	
openFile:	li	$v0, 13			# OPEN-FILE: PROCEDURA CHE PERMETTE DI APRILE UN FILE IN SOLO LETTURA
		li	$a1, 0	        	# PARAMETRI : $a0<--DESCRITTORE DEL FILE 
		li	$a2, 0
		syscall
		
		jr $ra				# VALORE DI RITORNO :	$v0<--REGISTRO DEL BUFFER CON I DATI LETTI 
					
readFile:	li 	$v0, 14			# READ-FILE: PROCEDURA PER LEGGERE IL CONTENUTO DEL FILE
		syscall				# $a1<-- REGISTRO CHE CONTIENE L'INDIRIZZO DI PARTENZA DEL BUFFER DI RIFERIMENTO  
						# $a2<-- GRANDEZZA DEL BUFFER DI RIFERIMENTO 
			
		jr $ra				# VALORE DI RITORNO:	$v0<--REGISTRO DEL BUFFER CON I DATI LETTI  	


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
		jr $ra


# setStatusABC setta l'array degli stati dedicati alle procedure ABC
# ofsetper leggere lo stato : 0 è A , 12 è B,  24 è C
# 	
setStatusABC:	addi 	$sp, $sp, -4
		sw 	$ra, 0($sp)
		
		move	$t9, $a0 	# faccio una copia perche torna comodo
	
		jal algAStatus
	
		addi $a0, $a0, 12
		jal algBStatus
	
		addi $a0, $a0, 12
		jal algCStatus
	
		move	$v0, $t9	# ritorno il registro di inzio 
	
		lw	$ra, 0($sp)
		addi	$sp, $sp, 4	
		jr $ra		
				

exit:								# fine del programma
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
		
