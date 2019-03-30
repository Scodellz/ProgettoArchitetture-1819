# GRUPPO DI LAVORO :
# DUCCIO SERAFINI			E-MAIL: duccio.serafini@stud.unifi.it
# ANDRE CRISTHIAN BARRETO DONAYRE	E-MAIL: andre.barreto@stud.unifi.it
# 
# DATA DI CONSEGNA 
#
#

.data 
# STRINGHE DEDICATE ALLA VISUALIZZAZIONE DEL MENU' PRINCIPALE
	welcome: 	.asciiz 	" Benvenuto! scelgliere una delle tre opzioni:\n"
	firstChoice:	.asciiz		" Premi 1 - per criptare il messaggio.\n "
	secondChoice:	.asciiz		"premi 2 - per decriptare il messaggio.\n "
	thirdChoice:	.asciiz		"premi 0 - per terminare il programma.\n "
	Choice:		.asciiz		"opzione: "
# STRINGHE DEDICATE PER LA VISUALIZZAZIONE DELLA OPERAZIONE IN CORSO
	criptaggio:	.asciiz		" criptaggio in corso..."
	decriptaggio:	.asciiz		" decriptaggio in corso..."
	done:		.asciiz 	"\n operazione terminata. " 
# 

.align 2
# JAT TABLE DEDICATA ALLA GESTIONE DEL MENU' INIZIALE
	menuJAT:		.space		8

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

					
	jal 	menuIniziale		# presentazione del menù iniziale
	jal	initMenùJat		# chiama la procedura che inizializza la tabella dei salti per il menù
	
	li	$v0, 5			# lettura della scelta effetuata 
		syscall			# il numero letto si troverà in $v0
	move	$a0, $v0		# passo il parametro 
	jal	calcoloScelta
	
	# COME PASSARE LA COSTANTE PER IL CALCOLO DEGLI INDIRIZZI?
	# JAL CALCOLO SCELTA  
	
	
	j 	exit

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
	
#casi del MenuJAT e' qui dove devono essere caricati i vari flag di controllo ,e fare i jal alle varie procedure 
					
cript:		li	$v0, 4				# eseguiamo le procedure di decriptaggio
		la	$a0, criptaggio			
		syscall 
		
		j	exit	
						
decrip:		li	$v0, 4				# eseguiamo le procedure di decriptaggio
		la	$a0, decriptaggio		# ci deve essere un controllo sull'operazione di decriptaggio,				# perche se il file letto è vuoto, messaggio di err	
		syscall 				# oppure mettere nella discrizione che non sono stati tenuti conti di certi casi 
							#
		j	exit				# oppure di riproporre direttamente il menu principale 	
		
uscita:		j 	exit				# salta alla sezione di uscita
	
# ***** PROCEDURA CHE INIZIALIZZA GLI INDIRIZZI DI SALTO DEDICATI AL MENU PRINCIPALE  
initMenùJat:	la	$t4, menuJAT			
		la	$t5, uscita
		sw	$t5, 0($t4)		# carico il caso dell'uscita nella posizione zero			
		la	$t5, cript
		sw	$t5, 4($t4)		# carica le chiamate alle procedure di criptaggio in prima posizione 
		la	$t5, decrip
		sw	$t5, 8($t4)		# carica le chiamate alle procedure di decriptaggio in seconda posizione
		
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
		