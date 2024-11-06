.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)

    li t1, 0
    li t2, 1

	# Begin prologue 
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	# End prologue

	addi s0, a0, 0							# s0 = matrix 
	addi s1, a1, 0							# s1 = matrix size
	addi t0, x0, 0							# t0 = max = 0
	addi t1, x0, -1							# t1 = i = -1
#	li a0, -1										# a0 = index = -1

for_loop:
	addi t1, t1, 1								# t1 = i++
	bge t1, s1, argmax_end			# if(i >= matrix_size), goto argmax_end
	slli t2, t1, 2								# t2 = offset = 4 * i
	add t2, t2, s0							# t2 = base + offset = matrix[i] address
	lw t2, 0(t2)								# t2 = matrix[i] value
	bge t0, t2, for_loop					# if(max >= matrix[i]), goto for_loop
	addi t0, t2, 0								# otherwise, t0 = max = matrix[i]
	addi t3, t1, 0								# t3 = index = i
	j for_loop
	
argmax_end:
	addi a0, t3, 0
	# Begin epilogue
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	addi sp, sp, 12
	# End epilogue
	ret

handle_error:
    li a0, 36
    j exit
