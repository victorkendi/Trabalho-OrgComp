.data
	menuInicial: .asciiz " Calculo (C) ou memoria (M)\n"
	menuSec1:    .asciiz "Adicao (+)\nSubtracao (-)\nDivisao (/)\nMultiplicacao (*)\nPotenciacao (^)\nRaiz quadrada (R)\nTabuada de 1 numero fornecido (T)\nFatorial de 1 numero fornecido (!)\nCalculo da sequencia de Fibonacci dado um intervalo (F)\n"
	menuSec2:    .asciiz "Memoria 1 (M1), Memoria 2 (M2), Memoria 3 (M3)\n"
	div0:	     .asciiz "Divisao por zero nao existe, digite outro valor\n"
	op:	     .space  2
	n1:	     .asciiz "primeiro numero\n"
	n2:	     .asciiz "segundo numero\n"
	n: 	     .asciiz "Numero\n"
	newline:	     .asciiz "\n"
	#adi:	     .byte   '+'
	#sinal $s7
	#numeros da operacao $s5 $s6
	#resultado $s0
.text

main:
	
	li $v0, 4 # set syscall para print
	la $a0, menuInicial
	syscall 
	
	li $v0, 8 # set syscall para receber string
	li $a1, 2 # set numero maximo de bytes a serem lidos p/ 2
	la $a0, op # coloca o enderco de op em $a0
	syscall
	
	li $v0, 4 # set syscall para print
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
	li $v0, 4 # set syscall para print
	la $a0, menuSec1
	syscall
	
	li $v0, 8
	la $a0, op
	li $a1, 2
	syscall
	
	li $v0, 4 # set syscall para print
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
	li $v0, 4 # set syscall para print
	la $a0, n1
	syscall
	
	li $v0, 5
	syscall
	
	move $s6, $v0
   
numeros2:
	li $v0, 4 # set syscall para print
	la $a0, n2
	syscall
	
	li $v0, 5
	syscall
	
	move $s5, $v0
	jal checkdiv0
	beq $s7, '+', adicao
	beq $s7, '-', subtracao
	beq $s7, '/', divisao
	beq $s7, '*', multiplicacao
	beq $s7, 'F', fibonacci
   
checkdiv0:
	bne $s7, '/', endfunction
	bne $s5, $zero, endfunction
	li $v0, 4 # set syscall para print
	la $a0, div0
	syscall
	j numeros2   
	
adicao:
	add $s0, $s5, $s6
	j endcalculo

subtracao:
	sub $s0,$s5,$s6
	j endcalculo

divisao:
	div $s0,$s5,$s6
	j endcalculo

multiplicacao:
	mul $s0,$s5,$s6
	j endcalculo

fibonacci:

   
endcalculo:
	#armazenamento na memoria
	
	li $v0, 1
	la $a0, ($s0) #resultado
	syscall
	
	li $v0, 4 # set syscall para print
	la $a0, newline
	syscall
	
	j main
	
numero:
	li $v0, 4 # set syscall para print
	la $a0, n
	syscall
	
	li $v0, 5
	syscall
	
	move $s6, $v0
	beq $s7, '^', potenciacao
	beq $s7, 'R', raiz
	beq $s7, 'T', tabuada
	beq $s7, '!', fatorial
	
potenciacao:
   
raiz:
   
tabuada:
   
fatorial:
	move $a0, $s6 # coloca o operando em $a0
	addi $a1, $a0, -1 # coloca o operando-1 em $a1
	addi $a2, $zero, 1 # coloca zero em a2
	
	jal fatorial_recursao
	move $s0,$a0
	j endcalculo
	
fatorial_recursao:
	beq $a1, $a2, endfunction # se a1 = 0 termina a recursão
	mul $a0, $a0, $a1 # a0 = a0*a1
	addi $a1, $a1, -1 # a1 = a1-1
	j fatorial_recursao
   
memoria:
   
endfunction:
	jr $ra
