.data
	menuInicial: .asciiz " C�lculo (C) ou mem�ria (M)\n"
	menuSec1:    .asciiz "Adi��o (+)\nSubtra��o (-)\nDivis�o (/)\nMultiplica��o (*)\nPotencia��o (^)\nRaiz quadrada (R)\nTabuada de 1 n�mero fornecido (T\nFatorial de 1 n�mero fornecido (!)\nC�lculo da sequ�ncia de Fibonacci dado um intervalo (F)\n"
	menuSec2:    .asciiz "Mem�ria 1 (M1), Mem�ria 2 (M2), Mem�ria 3 (M3)\n"
	div0:	     .asciiz "Divis�o por zero nao existe, digite outro valor\n"
	op:	     .space  2
	n1:	     .asciiz "1� n�mero\n"
	n2:	     .asciiz "2� n�mero\n"
	n: 	     .asciiz "N�mero\n"
	newline:	     .asciiz "\n"
	#adi:	     .byte   '+'
	#sinal $s7
	#numeros da opera�ao $s5 $s6
	#resultado $s0
.text
   main:
	li $v0 4
	la $a0, menuInicial
	syscall 
	
	li $v0, 8
	la $a0, op
	li $a1, 2
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	j selecao
	#lbu $t1, adi
	#li  $t0, '+'
	#beq $t1, $t0, printf
	
   exit:
	li $v0, 10
	syscall
	
   selecao:	
	lbu $t1, op
	li $t0, 'C'
	beq $t1, $t0, calculo
	
	lbu $t1, op
	li $t0, 'M'
	bne $t1, $t0, exit
	beq $t1, $t0, memoria
	
	j main
	
   calculo:
   	li $v0, 4
   	la $a0, menuSec1
   	syscall
   	
   	li $v0, 8
   	la $a0, op
   	li $a1, 2
   	syscall
   	
   	li $v0, 4
   	la $a0, newline
   	syscall
   	
   	lbu $s7, op
   	beq $s7, '+', numeros1
   	beq $s7, '-', numeros1
   	beq $s7, '/', numeros1
   	beq $s7, '*', numeros1
   	beq $s7, '^', numero
   	beq $s7, 'R', numero
   	beq $s7, 'T', numero
   	beq $s7, '!', numero
   	beq $s7, 'F', numeros1
   	
   numeros1:
   	li $v0, 4
   	la $a0, n1
   	syscall
	
	li $v0, 5
	syscall
	
	move $s6, $v0
   
   numeros2:	
	li $v0, 4
   	la $a0, n2
   	syscall
	
	li $v0, 5
	syscall
	
   	move $s5, $v0
   	jal checkdiv0
   	beq $s7, '+', adi�ao
   	beq $s7, '-', subtra�ao
   	beq $s7, '/', divisao
   	beq $s7, '*', multiplica�ao
   	beq $s7, 'F', fibonacci
   
   checkdiv0:
   	bne $s7, '/', endfunction
   	bne $s5, $zero, endfunction
   	li $v0, 4
   	la $a0, div0
   	syscall
   	j numeros2   	
   	
   adi�ao:
   	add $s0, $s5, $s6
   	j endcalculo
   subtra�ao:
   
   divisao:
   
   multiplica�ao:
   
   fibonacci:
   
   endcalculo:
   	#armazenamento na memoria
   	
   	li $v0, 1
   	la $a0, ($s0) #resultado
   	syscall
   	
   	li $v0, 4
   	la $a0, newline
   	syscall
   	
   	j main
   	
   numero:
   	li $v0, 4
   	la $a0, n
   	syscall
	
	li $v0, 5
	syscall
	
	move $s6, $v0
   	beq $s7, '^', pontencia�ao
   	beq $s7, 'R', raiz
   	beq $s7, 'T', tabuada
   	beq $s7, '!', fatorial
   	
   potencia�ao:
   
   raiz:
   
   tabuada:
   
   fatorial:
   
   
   
   memoria:	
   
   endfunction:
   	jr $ra
   

   
   	
   
   	
