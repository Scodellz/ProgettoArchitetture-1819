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
		

		la	$a0, messaggio 		# la chiamata a queste procedure mi permettono di caricare
		jal	readMessage		# i buffer interessati
		
		la	$a0,chiave
		jal	readKey			
			
		li	$s7, 0			# inizializo $s7 per usarla come VARIABILE DI STATO							
		
		# jal	cifratura		# chiamo la procedura di CIFRATURA 
	
		li	$v0, 4			
		la	$a0, bufferReader
		syscall
		
		# addi	$s7, $s7, 1		# avvio fase decifratura 
		
		# la	$a0,chiave
		# jal	readKey	
		
		# la 	$a0,messaggioDecifrato
		# jal	readMessage		
		
		# jal 	decrifratura
		
		# scrivi su file di uscita		
		
		j 	exit


# MAIN PROCEDURES :VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV					
									
	
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


# PROCEDURA GENERICA DEDICATA ALL'INVERSIONE DI QUALCUASI STRINGA SIA DATA IN PASTO 
# PARAMETRI : $a2 <--- bufferReader , buffer contenente la stringa a invertire 
#	      $a3 <--- buffer di support alla procedura di inversione
	
algD:		add	$sp, $sp, -4
		sw	$ra, 0($sp)
		
		move	$t9, $a2 		# faccio una copia perche mi serve
		move	$t8, $a3
		
		move	$t0, $zero			# Inizializzo contatore degli elementi della stringa a 0

		jal	bufferLenght
	

reversal:					# Metodo di inversione				
		beq	$t0, $s0, swapVet		# Se il numero dei caratteri inseriti è pari alla lunghezza del buffer
						# allora posso uscire dalla procedura	
		lbu	$t1, ($a2)			# Altrimenti metto in $t1 l'elemento del buffer di input
		sb	$t1, ($a3)			# e lo salvo nel buffer di uscita
		
		li	$t5, 1
		sub	$a2, $a2, $t5			# Vado al carattere precedente del buffer di input
		addi	$a3, $a3, 1			# Scorro alla posizione successiva del buffer di output
		addi	$t0, $t0, 1			# Aumento di 1 il contatore dei caratteri inseriti
	
		j 	reversal
	
swapVet: 
		move	$a2, $t9
		move	$a3, $t8
		jal	overWrite
	
		move	$v0, $v1
	
		lw	$ra, 0($sp)
		add	$sp, $sp, 4
		
		jr	$ra				# fine algoritmo D
	
# procedura dedicata all'algoritmo D
# conta la lunghezza dell'array
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
		
# fine del programma
exit:
		lw 	$ra, 0($sp)
		lw 	$s0, 4($sp)
		lw 	$s1, 8($sp)
		lw 	$s2, 12($sp)
		addi 	$sp, $sp, 16
	
		li	$v0, 4				
		la	$a0, done		# visualizza il messaggio di terminazione del programma							
		syscall				
	
		li $v0,10
		syscall		
		
