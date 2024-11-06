.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0        
	
	# Begin prologue 
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	# End prologue

	addi s0, a0, 0							# s0 = matrix 
	addi s1, a1, 0							# s1 = matrix size
	addi t0, x0, 0							# t0 = i = 0

for_loop:
    bge t0, s1, relu_end					# if (i >= size), goto relu_end
	slli t1, t0, 2								# t1 = offset = 4 * i
	add t1, s0, t1							# t1 = base + offset = s0[i] address
	lw t2, 0(t1)								# t2 = s0[i] value
	addi t0, t0, 1								# t0 = i++
	bge t2, x0, for_loop					# if (s0[i] >= 0), goto for_loop
	sw x0, 0(t1)								# otherwise, s0[i] = 0
    j for_loop
	
relu_end:
	# Begin epilogue
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	addi sp, sp, 12
	# End epilogue
	ret

error:
    li a0, 36          
    j exit          
