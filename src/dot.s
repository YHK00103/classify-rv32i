
.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0                                    # t0 = sum = 0
    li t1, 0                                    # t1 = i = 0

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation

    # mul t2, t1, a3                     # a0[i * stride]
    addi t2, x0, 0                      
    addi t3, x0, 0
mul_loop_1:
    bge t3, t1, mul_loop_end_1
    add t2, t2, a3
    addi t3, t3, 1
    j mul_loop_1

mul_loop_end_1:                              
    slli t2, t2, 2
    add t3, a0, t2
    lw t3, 0(t3)                          # t3 = a0[i * stride]

    # mul t4, t1, a4                   # a1[i * stride]
    addi t4, x0, 0                      
    addi t5, x0, 0
mul_loop_2:
    bge t5, t1, mul_loop_end_2
    add t4, t4, a4
    addi t5, t5, 1
    j mul_loop_2

mul_loop_end_2:     
    slli t4, t4, 2
    add t5, a1, t4
    lw t5, 0(t5)                         # t5 =  a1[i * stride]

   # mul t6, t3, t5
    li t6, 0
    li t2, 0
    mv t4, t3
    bltz t4, neg_num               # check if negative number multiplication
    beqz t4, mul_loop_end_3

mul_loop_3:
    bge t2, t3, mul_loop_end_3
    add t6, t6, t5
    addi t2, t2, 1
    j mul_loop_3

neg_num:
    neg t4, t4                             # t4 = -t4

neg_mul_loop:                        # negative number multiplication
    sub t6, t6, t5
    addi t4, t4, -1
    bnez t4, neg_mul_loop

mul_loop_end_3:
    add t0, t0, t6                      # t0 = sum += a0[i * stride] * a1[i * stride]
    addi t1, t1, 1                      # t1 = i++
    j loop_start

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
