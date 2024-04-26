.data
size:      .asciiz "\nInserte el numero de elementos para la lista\n"
elements:  .asciiz "Inserte los numeros para el array:  \n"
sorted:    .asciiz "Array ordenado:   "
c:         .asciiz ", "
d:         .byte '.'
n:         .byte '\n'
.text
.globl main

main:
    li  $v0, 4           
    la  $a0, size       
    syscall              
                                
    li  $v0, 5           
    syscall                          
    move $s2, $v0                     

    li  $v0, 4                       
    la  $a0, elements                 
    syscall                         

    move $s1, $zero                  

run_loop:
    bge $s1, $s2, exit_loop               

    sll $t0, $s1, 2                 
    add $t1, $t0, $sp               

    li  $v0, 5                      
    syscall                                    

    sw  $v0, ($t1)                  

    li  $v0, 4                      
    la  $a0, n                     
    syscall                          

    addi $s1, $s1, 1                 
    j run_loop                       

exit_loop:
    move $a0, $sp                   
    move $a1, $s2                   
    jal  Selection_Sort              

    li  $v0, 4                      
    la  $a0, sorted               
    syscall                         

    jal  print                     

    li  $v0, 10                    
    syscall                        

print:
    move $s1, $zero                 

ploop:
    bge  $s1, $s2, exit_print              

    sll  $t0, $s1, 2                
    add  $t1, $t0, $sp                            

    lw   $a0, ($t1)                 
    li   $v0, 1                     
    syscall                          

    addi $s1, $s1, 1                 

    bge  $s1, $s2, exit_temp               

    li   $v0, 4                    
    la   $a0, c                     
    syscall                       

exit_temp:
    j ploop                        

exit_print:
    li  $v0, 4                      
    la  $a0, d                       
    syscall                         

    li  $v0, 10                      
    syscall                        

Selection_Sort:
    addi $sp, $sp, -16               
    sw   $s0, 0($sp)                
    sw   $s1, 4($sp)               
    sw   $s2, 8($sp)                 
    sw   $ra, 12($sp)               

    move $s0, $a0                    
    move $s1, $zero                 
    subi $s2, $a1, 1                

Sort_loop:
    bge  $s1, $s2, Selection_Sort_exit               

    move $a0, $s0                    
    move $a1, $s1                                
    move $a2, $s2                   
    jal  max                       
    move $a2, $v0                 
    jal  swap                        
    addi $s1, $s1, 1              
    j    Sort_loop                

Selection_Sort_exit:
    lw   $s0, 0($sp)                
    lw   $s1, 4($sp)                         
    lw   $s2, 8($sp)                 
    lw   $ra, 12($sp)               
    addi $sp, $sp, 16                
    jr   $ra                         

max:
    move $t0, $a0                   
    move $t1, $a1                    
    move $t2, $a2                   
    move $t5, $t1                  

    sll  $t3, $t1, 2                
    add  $t3, $t3, $t0               
    lw   $t4, 0($t3)                

max_loop:
    bgt  $t5, $t2, max_exit               

    sll  $t6, $t5, 2                
    add  $t6, $t6, $t0              
    lw   $t7, 0($t6)                 

    bge  $t7, $t4, chk_exit              

    move $t1, $t5                  
    move $t4, $t7                  
    
chk_exit:
    addi $t5, $t5, 1                
    j    max_loop                  

max_exit:
    move $v0, $t1                    
    jr   $ra                         

swap:
    sll  $t1, $a1, 2                
    add  $t1, $t1, $a0               

    sll  $t2, $a2, 2                 
    add  $t2, $t2, $a0              

    lw   $t0, 0($t1)                
    lw   $t3, 0($t2)               

    sw   $t3, 0($t1)               
    sw   $t0, 0($t2)               

    jr   $ra                        