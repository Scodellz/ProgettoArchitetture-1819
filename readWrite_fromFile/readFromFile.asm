.data
.align 2
bufferReader :	  .space  1024	
filePath: 	  .asciiz ".marSETUP/chiave.txt"

.text

main: 	   li   $v0,13			# chiamata di sistema per apertura files
	   la   $a0,filePath
	   li   $a1,0			#modalita di apertura (solo lettura)
	   li   $a2,0	
	   syscall 
	   move $t6,$v0   		# 

readData:  li   $v0,14    		# chiamata di sistema per leggere
	   move $a0,$t6  		# specifico il percorso da dove leggere
	   la   $a1,bufferReader 	# carico l'indirizzo di PARTENZA del buffer
	   li   $a2,1024
	   syscall 
	   
printFile: li   $v0,4			# STAMPA l'intero buffer
	   la	$a0,bufferReader	# chiamata di sistema per stampare
	   syscall 
	   
						   	   	    	   	    	   	   
closefile: li   $v0,16
	   move $a0,$t6
	   syscall 

closeProg: li $v0,10
	   syscall  

 
