# GRUPPO DI LAVORO :
# DUCCIO SERAFINI			E-MAIL: duccio.serafini@stud.unifi.it
# ANDRE CRISTHIAN BARRETO DONAYRE	E-MAIL: andre.barreto@stud.unifi.it
# 
# DATA DI CONSEGNA: 
#
#

.data 
# STRINGHE DEDICATE ALLA VISUALIZZAZIONE DEL MENU' PRINCIPALE
	welcome: 	.asciiz 	" Benvenuto! scelgli una delle tre opzioni:\n"
	firstChoice:	.asciiz		" Premi 1 - per cifrare il messaggio.\n "
	secondChoice:	.asciiz		"premi 2 - per decifrare il messaggio.\n "
	thirdChoice:	.asciiz		"premi 0 - per terminare il programma.\n "
	Choice:		.asciiz		"opzione: "
# STRINGHE DEDICATE PER LA VISUALIZZAZIONE DELLA OPERAZIONE IN CORSO
	cifraturaaggio:	.asciiz		" cifraturaaggio in corso..."
	decifraturaaggio:	.asciiz		" decifraturaaggio in corso..."
	done:		.asciiz 	"\n operazione terminata. " 
# DESCRITTORI DEI FILE IN INGRESSO 
	messaggio:	.asciiz		".marSETUP/messaggio.txt"
	chiave:		.asciiz 	".marSETUP/chiave.txt"
# DESCRITTORI DEI FILE IN USCITA 


.align 2
# JAT TABLE DEDICATA ALLA GESTIONE DEL MENU' INIZIALE
	menuJAT:	.space		8
# BUFFER DEDICATI ALLA LETTURA DEI DATI DEI FILE IN INPUT
	bufferReader:	.space	    255
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

	jal	initmenuJAT		# chiama la procedura che inizializza la tabella dei salti per il menù				
	jal 	menuIniziale		# presentazione del menù iniziale
	li	$v0, 5			# lettura della scelta effetuata 
		syscall			# il numero letto si troverà in $v0
		
	move	$a0, $v0		# passo il parametro 
	jal	calcoloScelta
	
	j 	exit
	
#casi del MenuJAT e' qui dove devono essere caricati i vari flag di controllo ,e fare i jal alle varie procedure 
					
cifratura:		li	$v0, 4				# eseguiamo le procedure di decifraturaaggio
		la	$a0, cifraturaaggio			
		syscall 
		
		jal	leggiChiave
		
		jal	leggiMessaggio
		
		
		j	exit	
						
decrifratura:		li	$v0, 4				# eseguiamo le procedure di decifraturaaggio
		la	$a0, decifraturaaggio		# ci deve essere un controllo sull'operazione di decifraturaaggio,				# perche se il file letto è vuoto, messaggio di err	
		syscall 				# oppure mettere nella discrizione che non sono stati tenuti conti di certi casi 
		
# la prima cosa da fare qui dentro è chiamare una procedura che controlli se il file "messaggioDEcifrato è pieno"
# se non lo è stampa una strina di errore e ripropone il menu iniziale 

# se il controllo viene superato, l'algoritmo diD per invertire la chiave 

# e si esegue la procedura di cifraturaaggio		
												
		j	exit				# oppure di riproporre direttamente il menu principale 	
		
uscita:		j 	exit				# salta alla sezione di uscita


# PROCEDURA DEDICATA ALLA LETTURA DELLE CHIAVI SIA IN FASE DI CRIPTAGGIO CHE DECRIPTAGGIO (IN CUI PRIMA DI SCRIVERLA LA DEVE INVERTIRE )
#
# 
leggiChiave:
	addi 	$sp, $sp, -4
	sw   	$ra, 0($sp)		# salvo il rigistro di ritorno del chiamante 
	
	la	$a0, chiave		# carico il descrittore del file
	jal 	openFile		# apro il file in solo lettura
	
	move	$a0, $v0		# passo il descrittore del file alla prossima procedura
	la	$a1, bufferKey
	li	$a2, 5
	jal	readFile
	
	move	$a0, $a1
	jal 	printContent
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	
	jr 	$ra
	
# ****************************************************************************************************	

leggiMessaggio:
	addi 	$sp, $sp, -4
	sw   	$ra, 0($sp)		# salvo il rigistro di ritorno del chiamante 
	
	la	$a0, messaggio		# carico il descrittore del file
	jal 	openFile		# apro il file in solo lettura
	
	move	$a0, $v0		# passo il descrittore del file alla prossima procedura
	la	$a1, bufferReader
	li	$a2, 255
	jal	readFile
	
	move	$a0, $a1
	jal 	printContent
	
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

# procedura che calcola la posizione in cui saltare nella menuJAT  
calcoloScelta:	
	slt	$t1, $a0, $zero		# confronta se la scleta insierita e' < = 0
	bne	$t1, $zero, exit
	slti	$t1, $v0, 3		# controllo che la scelta sia < =3
	beq 	$t1, $zero, exit
	li	$t2, 4			# costante di default per il calcolo dell'indirizzo in cui saltare
	mult	$t2, $a0		# moltiplico la costante per la scelta 
	mflo	$t3			# riprendo il risultato dal regristro dedicato alla moltiplicazione																							
	lw	$t0, menuJAT($t3)	# carico la posizione richiesta 																			
	jr	$t0			# viene eseguito il salto alla posizione richiesta
	
# ***** PROCEDURA CHE INIZIALIZZA GLI INDIRIZZI DI SALTO DEDICATI AL MENU PRINCIPALE  
initmenuJAT:	la	$t4, menuJAT			
		la	$t5, uscita
		sw	$t5, 0($t4)		# carico il caso dell'uscita nella posizione zero			
		la	$t5, cifratura
		sw	$t5, 4($t4)		# carica le chiamate alle procedure di cifraturaaggio in prima posizione 
		la	$t5, decrifratura
		sw	$t5, 8($t4)		# carica le chiamate alle procedure di decifraturaaggio in seconda posizione
		
		move	$v0, $t4		# salvo l'indirzzo della menuJAT in $v0
		jr	$ra

# ***** PROCEDURA CHE STAMPA IL MENU' DI SCELTA PRINCIPALE ***** #
menuIniziale:	li	$v0, 4				
		la	$a0, welcome			 
		syscall					 			
		la	$a0, firstChoice		
		syscall 						
		la	$a0, secondChoice		
		syscall 								
		la	$a0, thirdChoice			
		syscall
		la	$a0, Choice
		syscall 
		jr	$ra	

# ********************************************************
# fine del programma
		
exit:
	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s1, 8($sp)
	lw 	$s2, 12($sp)
	addi 	$sp, $sp, 16
	
	li	$v0,4				
	la	$a0, done			# visualizza il messaggio di terminazione del programma							
	syscall				
	
	li $v0,10
	syscall
		
	# jr $ra 	# forse si toglie, forse no, da chiedere a chiara
		
