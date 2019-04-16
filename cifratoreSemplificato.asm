# GRUPPO DI LAVORO :
# DUCCIO SERAFINI			E-MAIL: duccio.serafini@stud.unifi.it
# ANDRE CRISTHIAN BARRETO DONAYRE	E-MAIL: andre.barreto@stud.unifi.it
# 
# DATA DI CONSEGNA: 
#
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
		

		la	$a0, messaggio 		# la chiamata a queste procedure mi permettono di caricare
		jal	readMessage		# i buffer interessati
		
		la	$a0,chiave
		jal	readKey			
			
		li	$s7, 0			# inizializo $s7 per usarla come VARIABILE DI STATO							
		
		# jal	cifratura		# chiamo la procedura di CIFRATURA 
	
		li	$v0, 4			# DA ELIMINARE sostituire con la procedura scrittura su file
		la	$a0, bufferReader
		syscall
		
		# addi	$s7, $s7, 1
		
		# CHIAMA INVERTER PER INVERTIRE LA CHIAVE E METTERLA SU BUFFERKEY
		
		# CHIAMA READFILE SU MESSAGGIOCIFRATO E METTERLO SU BUFFERREADER
		
		#jal 	decrifratura	
		
		j 	exit
				
		
	
		
		
		j exit 
		#leggi chiave
		

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
			
		lw	$ra, 0($sp)		# reimposto il registro del chiamante
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
		
