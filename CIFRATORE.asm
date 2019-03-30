# GRUPPO DI LAVORO :
# DUCCIO SERAFINI			E-MAIL:
# ANDRE CRISTHIAN BARRETO DONAYRE	E-MAIL: andre.barreto@stud.unifi.it
# 
# DATA DI CONSEGNA 
#
#

.data 
# Stringhe dedicate al menu di benvenuto 
	welcome: 	.asciiz 	" Benvenuto! scelgliere una delle tre opzioni:\n"
	firstChoice:	.asciiz		" Premi 1 - per criptare il messaggio.\n "
	secondChoice:	.asciiz		"premi 2 - per decriptare il messaggio.\n "
	exit:		.asciiz		"premi 0 - per terminare il programma.\n "
#

.align 2
# JAT Table dedicata alla gestione del menu
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

#*****PRESENTAZIONE DEL MENU PRINCIPALE PER LA SCELTA DELLE AZIONI 

	jal 	menuIniziale
	
	j 	esci


menuIniziale:	li	$v0, 4				# Stampa il menu di scelta di benvenuto  
		la	$a0, welcome			 
		syscall					 			
		la	$a0, firstChoice		
		syscall 						
		la	$a0, secondChoice		
		syscall 								
		la	$a0, exit			
		syscall 
		jr	$ra	

# ********************************************************
# fine del programma
esci:		


	lw 	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw 	$s1, 8($sp)
	lw 	$s2, 12($sp)
	addi 	$sp, $sp, 16
	
	li $v0,10
	syscall
		
	# jr $ra 	# forse si toglie, forse no, da chiedere a chiara




































	

						