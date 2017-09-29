# Sa�l Antonio Rodr�guez Lillingston
# Gerardo Cruz Plazola	
# Pr�ctica 1 - Torres de Hanoi

.data
		
.text
	addi $a0, $zero, 0x10008000 	#direcci�n de memoria de torre 1
#--------------------------offset para reservar memoria din�mica-------------------------
	addi $s1, $zero, 3 		# n�mero de discos
	add $s2, $zero, $s1 		# num de discos para salida de recursi�n
	sll $s3, $s1, 2   		# num de discos multiplicado por 4, offset
#-------------------------Direcci�n de memoria del resto de las torres-------------------
	add $a1, $a0, $s3 		#direcci�n de memoria de torre 2
	add $a2, $a1, $s3		#direcci�n de memoria de torre 3
	#addi $a1, $a1, 4		#primera direcci�n torre 2
	#addi $a2, $a2, 4		#first direction in tower 3
#------------------------- variables de rellenado----------------------------------------
	add $s0, $zero, $s1		#discos a rellenar
	
#-------------------------Rellenado de discos--------------------------------------------
rellenadoDeDiscos:
	sw $s0, 0($a0)
	addi $a0, $a0, 4
	addi $s0, $s0, -1
	bne $s0, $zero , rellenadoDeDiscos	#comparaci�n entre contador y num de discos+1
#----------------------------------------------------------------------------------------
	addi $a0, $a0, -4 		#ajustar a �ltima posici�n de torre 1 al �ltimo disco
main:
	jal Hanoi
	j exit
	
Hanoi:
	beq $s1, 1, CasoBase 		#verificaci�n de caseo base, discos = 1
	add $t7, $a1, $zero		#se voltean las torres del paso 1 para siguiente iteraci�n recursiva
	add $a1, $a2, $zero		#x2
	add $a2, $t7, $zero		#x3
	addi $sp, $sp, -8		#offset para variables de recursi�n
	
#-----------------------guarda variables de recursi�n en el stack-------------------------	
	sw $ra, 0($sp)			#return address	
	sw $s1, 4($sp)			#discos en el caso
#-----------------------------------------------------------------------------------------

	
	subi $s1, $s1, 1 		#resta uno a los discos para siguiente iteraci�n
	jal Hanoi			#next iteration


# Number of discs and return address ($ra) won't load as variables just yet, to correctly
# execute step-2 
#-----------------------------------------Step 2-------------------------------------------
	
	jal CasoBase
#-----------------------------------------Step 3-------------------------------------------
	lw $ra, 0($sp)			#return address	
	lw $s1, 4($sp)			#number of discs 
	
# Time to flip the towers for step 3
	add $t7, $a0, $zero
	add $a0, $a1, $zero
	add $a1, $t7, $zero
	add $t7, $a1, $zero
	add $a1, $a2, $zero
	add $a2, $t7, $zero
	jal Hanoi
					#return stack pointer to a right position
		
CasoBase:
	lw $t9, 0($a0)			#saca disco de torre origen
	sw $zero, 0($a0)		#store a 0 in the origin tower
	sw $t9, 0($a2)			#store disc in destination tower
	addi $a0, $a0, -4		#direction of the last disc contained in tower a0
	addi $a2, $a2, 4		#direction of the last disc contained in tower a2
	jr $ra

exit: