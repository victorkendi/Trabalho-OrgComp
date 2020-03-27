.data
	menuInicial: .asciiz " Cálculo (C) ou memória (M)\n"
	menuSec1:    .asciiz "Adição (+)\nSubtração (-)\nDivisão (/)\nMultiplicação (*)\nPotenciação (^)\nRaiz quadrada (R)\nTabuada de 1 número fornecido (T\nFatorial de 1 número fornecido (!)\nCálculo da sequência de Fibonacci dado um intervalo (F)\n"
	menuSec2:    .asciiz "Memória 1 (M1), Memória 2 (M2), Memória 3 (M3)\n"
	div0:	     .asciiz "Divisão por zero nao existe, digite outro valor\n"
	op:	     .space  2
	n1:	     .asciiz "1º número\n"
	n2:	     .asciiz "2º número\n"
	n: 	     .asciiz "Número\n"
	newline:	     .asciiz "\n"
	#adi:	     .byte   '+'
	#sinal $s7
	#numeros da operaçao $s5 $s6
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
   	beq $s7, '+', adiçao
   	beq $s7, '-', subtraçao
   	beq $s7, '/', divisao
   	beq $s7, '*', multiplicaçao
   	beq $s7, 'F', fibonacci
   
   checkdiv0:
   	bne $s7, '/', endfunction
   	bne $s5, $zero, endfunction
   	li $v0, 4
   	la $a0, div0
   	syscall
   	j numeros2   	
   	
   adiçao:
   	add $s0, $s5, $s6
   	j endcalculo
   subtraçao:
   
   divisao:
   
   multiplicaçao:
   
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
   	beq $s7, '^', pontenciaçao
   	beq $s7, 'R', raiz
   	beq $s7, 'T', tabuada
   	beq $s7, '!', fatorial
   	
   potenciaçao:
   
   raiz:
   
   tabuada:
   
   fatorial:
   
   
   
   memoria:	
   
   endfunction:
   	jr $ra
   

   
   	
   
   	
