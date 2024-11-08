# Assignment 2: Classify
In this project, we design a basic system using RISC-V assembly language, implementing fundamental matrix and vector operations, including matrix multiplication. These functions act as core components for building a simple Artificial Neural Network (ANN) aimed at classifying handwritten digits.

The project is organized into two main components:mathematical functions and file operations. The mathematical functions cover various matrix and vector operations, such as ```ReLU```, ```ArgMax```, ```Dot Product```, and ```Matrix Multiplication```. The second part includes all file-related operations and the main logic of the program.


## 1. Part A: Mathematical Functions

### 1.1 ReLU
In ```relu.s```, each element of the input array will be processed by setting negative values to 0. The operation is defined as:

```math
ReLU(a)=max(a,0)
```
The inputs for this operation and their corresponding registers are as follows:

*	```a0``` : (int*) pointer to interger array to be modified.
*	```a1``` : (int) number of elements in array.
  
First, the register ```t0``` is initialized as a counter ```i``` to track the position of the current element in the input array. The register ```t1``` holds the address of the i-th element, and the value at this address is loaded into register ```t2```. The operation then checks whether the value is negative. If it is, the value is set to 0; otherwise, it remains unchanged.

### 1.2 ArgMax
In ```argmax.s```, implement the argmax funxtion, which returns the index of the largest element in a given vector. The inputs for this operation and their corresponding registers are as follows:

*	```a0``` : (int*) pointer to the first element of the array.
*	```a1``` : (int) number of elements in the array.

The return for this operation and its corresponding register is as follows:
* ```a0``` : (int) position of the first maximum element.

The registers ```t0``` and ```t1``` are initialized with the maximum value of the input array and the counter ```i```, respectively. Using a for loop, the operation checks whether each element is greater than the current maximum value stored in register ```t0```. If an element is greater, the maximum value in ```t0``` and the index of the first occurrence of the maximum value in register ```a0``` are updated. The function returns the value in register ```a0``` upon completion.

### 1.3 Dot Product
In ```dot.s```, implement the dot product function, which calculates the dot product of two given vectors. It defined as:

```math
dot(a, b) = \sum_{i=0}^{n-1} (a_i · b_i)
```
The inputs for this operation and their corresponding registers are as follows:

*	```a0``` : (int*) pointer to the first input array (M1).
*	```a1``` : (int*) pointer to the second input array (M2).
*	```a2``` : (int) number of elements to process.
*	```a3``` : (int) skip distance in the first array.
*	```a4``` : (int) skip distance in the second array.

The return for this operation and its corresponding register is as follows:
*	```a0``` : (int) resulting for product value.

This operation implements a dot product calcuation function with strides. First, register ```t0``` is initialized to store the sum of the products. Then, the memory addresses of ```M1[i*stride]``` and ```M2[i*stride]``` are calculated, and the values at these addresses are loaded into registers ```t3``` and ```t5```, respectively.

Subsequently, the operation checks whether either the value at ```M1[i*stride]``` or ```M2[i*stride]``` is negative. If either value is negative, multiplication is performed using subtraction. Otherwise, multiplication is performed using addition.

Eventually, the sum register ```t0``` is updated by adding the result of the multiplication. Upon completion, the dot product value is returned.

### 1.4 Matrix Multiplication
In ```matmul.s```, implement the matrix multiplication, where:

```math
C[i][j]=dot(A[i],B[:j])
```
The inputs for this operation and their corresponding registers are as follows:

*	```a0``` : (int*) pointer to the memory address of the first matrix.
*	```a1``` : (int) row count of the first matrix.
*	```a2``` : (int) column count of the second matrix.
*	```a3``` : (int*) pointer to the memory address of the second matrix.
*	```a4``` : (int) row count of the first matrix.
*	```a5``` : (int) column count of the second matrix.
*	```a6``` : (int*) point to the memory address of output matrix.

The matrix multiplication operation relies on the dot product. It iterates through the rows of the first matrix with the outer loop, and through the columns of the second matrix with the inner loop, calculating the dot product of the corresponding elements. The ```dot``` function is called internally to compute the dot product of two arrays, which serves as the fundamental operation in matrix multiplication.

## 2. Part B: File Operations and Main

### 2.1 Read Matrix
In ```read_matrix.s```, implement the function to read a binary matrix from a file and load it into memory. The inputs for this operation and their corresponding registers are as follows:

* ```a0``` : (char*) pointer to filename string.
* ```a1``` : (int*) address to write row count.
* ```a2``` : (int*) address to write column count.

The function will return the following value in the specified register:
* ```a0``` : (int*) pointer to base address of loaded matrix.

The ```read_matrix``` function can be separate into three main parts, including open file, read row count and column count of the input matrix, and load input matrix. The details of each operation are as follows:

**2.1.1 Open File**

The file path is provided in register ```a0```, and register ```a1``` is set to ```0```, indicating read-only permission for accessing the file. The ```fopen``` function is then called. After this operation, the function will return a file descriptor in register ```a0```. If the value in register ```a0``` is ```-1```, it indicates that an error occurred while attempting to open the file with ```fopen```. Otherwise, the file has opened successfully.

**2.1.2 Read Row Count and Column Count of the Input Matrix**

The file descriptor is loaded into register ```a0```, the pointer to the buffer where the read bytes will be stored is loaded into register ```a1```, and the number of bytes to be read is loaded into register ```a2```. This operation reads 8 bytes, corresponding to the row count and column count of the input matrix. 

After calling the ```fread``` function, the operation checks whether the row and column count values were read sucessfully by comparing return value in register ```a0``` with register ```t0```. If the values were read sucessfully, the operation loads the two values from buffer into registers ```t1``` and ```t2```.

**2.1.3 Load Input Matrix**

In this section, the operation calculates the number of elements in the input matrix by multiplying the row count and column count. To avoid using M extension instruction for multiplication, the calculation is performed through repeated addition instead.

After calculating the number of elements in the input matrix, the operation calls the  ```malloc``` function to allocate memory for loading the input matrix. Then, the necessary registers are set up: file descriptor, the buffer for storing the read data, and the number of bytes to read. 

Using the ```fread``` function, the operation checks if the input matrix is loaded into the buffer successfully. If the matrix is read successfully, the file is closed with the ```fclose``` function. Otherwise, the program exits with the ```fread_error```.

### 2.2 Write Matrix
In ```write_matrix.s```, implement the function to write a matrix to a binary file. The function takes the following inputs with corresponding registers:

* ```a0``` : (char*) pointer to a string representing the filename.
* ```a1``` : (int*) pointer to the starting memory address of the matrix.
* ```a2``` : (int) number of rows in the matrix.
* ```a3``` : (int) number of columns in the matrix.

The ```write_matrix``` function can be divided into three sections: opening the file, writing the row count and column count of the result matrix, and writing the result matrix. The details of these operations are as follows:

**2.2.1 Open File**

The file path is loaded into register ```a0```, and the register ```a1``` is set to ```1```, which represents write-only permission for accessing the file. The ```fopen``` function is then called. After this operation, the function will return a file descriptor in register ```a0```. If the value in register ```a0``` is ```-1```, it indicates that an error occurred while attempting to open the file with ```fopen```. Otherwise, the file has opened successfully.

**2.2.2 Write the Row Count and Column Count of the Result Matrix**

The file descriptor is loaded into register ```a0```, and the buffer storing the row count and column count is loaded into register ```a1```. Registers ```a2``` and ```a3``` are set to ```2``` and ```4``` respectively, indicating that two elements (row count and column count) are written to the file with each element being 4 bytes. 

Using the ```fwrite``` function, the operation checks if the row count and column count are written to the file successfully by comparing the return value in register ```a0``` with the value stored in register ```t0```. If the row count and column count are not written to the file successfully, the program exits with the ```fwrite_error```. Otherwise, the program proceeds to write the result matrix to the file.

**2.2.3 Write the Result Matrix**

To calculate the total number of elements and avoid using M extension instructions, the multiplication is performed through repeated addition. The resulting value of calculation is stored in register ```a2```, representing the number of elements the operation will write to the file.

The same operation as writing the row count and column count is performed: the file descriptor, the buffer storing the result matrix, and the size of each element are loaded into registers ```a0```, ```a1```, and ```a3```, respectively.

By using the ```fwrite``` function, the operation checks if the result matrix is written to the file successfully. If the matrix is written successfully, the file is closed with the ```fclose``` function. Otherwise, the program exits with the ```fwrite_error```.

### 2.3 Classification
In ```classify.s```, the function binds all components necessary to classify an input using two weight matrices (```m0``` and ```m1```) and the specified operations.  The function takes in three parameters with corresponding registers as follows:

* ```a0``` : (int) argument count
* ```a1``` : (char**) argument vector
* ```a2``` : (int) silent mode flag

The classification result of this operation is returned in the following register:
* ```a0``` : (int) classification result

In this section, the operation can be divided into several parts, including reading the necessary matrices (```m0```, ```m1```, and the input matrix), matrix multiplication, ReLU activation, second matrix multiplication, and classification. The explanation of each operation is as follows:

**2.3.1 Read ```m0```, ```m1```, and the Input Matrix**

In order to store the row and column counts of each matrix, the operation allocates 4 bytes of memory for each value using the ```malloc``` function. The return value in register ```a0``` represents the allocated memory address for each value, which is then moved from register ```a0``` to a series of ```s``` registers (```s3``` to```s8```) for further use.

Next, the pointer to the filename string is loaded into register ```a0```, while the addresses for storing the row and column counts are loaded into registers ```a1``` and ```a2```, respectively. Through the ```read_matrix``` function, the memory address of each matrix is stored in register ```a0```. The operation loads these addresses into registers ```s0```, ```s1```, and ```s2```, indicating the memory addresses of ```m0```, ```m1```, and the input matrix.

**2.3.2 Matrix Multiplication**

The purpose of this section is to calculate the following formula:

```math
HiddenLayer = matmul(m0, input)
```
To avoid using M extension instructions, the operation implements multiplication using repeated addition to calculate the total number of elements in the ```hidden layer``` matrix. Then, the necessary values are loaded into the corresponding registers, and the operation performs matrix multiplication via the ```matmul``` function to obtain the ```hidden layer``` matrix. 

**2.3.3 ReLU Activation**

In this section, the implementation is as follows:

```math
HiddenLayer = relu(HiddenLayer)
```
First, the operation calculates the length of the ```hidden layer``` array using repeated addition. Then, the pointer to the ```hidden layer``` array and its length are loaded into registers ```a0``` and ```a1```, respectively. Through the ```relu``` function, an array without any negative values is returned.

**2.3.4 Second Matrix Multiplication**

In this section, the implementation is as follows:

```math
scores = matmul(m1, HiddenLayer)
```
The operation is the same as above. It first calculates the total number of elements in the ```scores``` matrix. Subsequently, the corresponding registers are set. Finally, the matrix multiplication result of ```m1``` and the ```hidden layer``` is calculated via the ```matmul``` function.

**2.3.5 Classification**

The goal of this section is to find out the classification of the input matrix. The formula of this operation is as follows:
```math
classification = argmax(scores)
```
The operation calculates the length of the ```scores``` array using repeated addition. Then, the pointer to the ```scores``` array and its length are loaded into registers ```a0``` and ```a1```, respectively. The ```argmax``` function is called to find the first maximum element in the ```scores``` array, which represents the classification of the input matrix.

## 3. Result
The following results were tested using the Venus simulator.
```
test_abs_minus_one (__main__.TestAbs.test_abs_minus_one) ... ok
test_abs_one (__main__.TestAbs.test_abs_one) ... ok
test_abs_zero (__main__.TestAbs.test_abs_zero) ... ok
test_argmax_invalid_n (__main__.TestArgmax.test_argmax_invalid_n) ... ok
test_argmax_length_1 (__main__.TestArgmax.test_argmax_length_1) ... ok
test_argmax_standard (__main__.TestArgmax.test_argmax_standard) ... ok
test_chain_1 (__main__.TestChain.test_chain_1) ... ok
test_classify_1_silent (__main__.TestClassify.test_classify_1_silent) ... ok
test_classify_2_print (__main__.TestClassify.test_classify_2_print) ... ok
test_classify_3_print (__main__.TestClassify.test_classify_3_print) ... ok
test_classify_fail_malloc (__main__.TestClassify.test_classify_fail_malloc) ... ok
test_classify_not_enough_args (__main__.TestClassify.test_classify_not_enough_args) ... ok
test_dot_length_1 (__main__.TestDot.test_dot_length_1) ... ok
test_dot_length_error (__main__.TestDot.test_dot_length_error) ... ok
test_dot_length_error2 (__main__.TestDot.test_dot_length_error2) ... ok
test_dot_standard (__main__.TestDot.test_dot_standard) ... ok
test_dot_stride (__main__.TestDot.test_dot_stride) ... ok
test_dot_stride_error1 (__main__.TestDot.test_dot_stride_error1) ... ok
test_dot_stride_error2 (__main__.TestDot.test_dot_stride_error2) ... ok
test_matmul_incorrect_check (__main__.TestMatmul.test_matmul_incorrect_check) ... ok
test_matmul_length_1 (__main__.TestMatmul.test_matmul_length_1) ... ok
test_matmul_negative_dim_m0_x (__main__.TestMatmul.test_matmul_negative_dim_m0_x) ... ok
test_matmul_negative_dim_m0_y (__main__.TestMatmul.test_matmul_negative_dim_m0_y) ... ok
test_matmul_negative_dim_m1_x (__main__.TestMatmul.test_matmul_negative_dim_m1_x) ... ok
test_matmul_negative_dim_m1_y (__main__.TestMatmul.test_matmul_negative_dim_m1_y) ... ok
test_matmul_nonsquare_1 (__main__.TestMatmul.test_matmul_nonsquare_1) ... ok
test_matmul_nonsquare_2 (__main__.TestMatmul.test_matmul_nonsquare_2) ... ok
test_matmul_nonsquare_outer_dims (__main__.TestMatmul.test_matmul_nonsquare_outer_dims) ... ok
test_matmul_square (__main__.TestMatmul.test_matmul_square) ... ok
test_matmul_unmatched_dims (__main__.TestMatmul.test_matmul_unmatched_dims) ... ok
test_matmul_zero_dim_m0 (__main__.TestMatmul.test_matmul_zero_dim_m0) ... ok
test_matmul_zero_dim_m1 (__main__.TestMatmul.test_matmul_zero_dim_m1) ... ok
test_read_1 (__main__.TestReadMatrix.test_read_1) ... ok
test_read_2 (__main__.TestReadMatrix.test_read_2) ... ok
test_read_3 (__main__.TestReadMatrix.test_read_3) ... ok
test_read_fail_fclose (__main__.TestReadMatrix.test_read_fail_fclose) ... ok
test_read_fail_fopen (__main__.TestReadMatrix.test_read_fail_fopen) ... ok
test_read_fail_fread (__main__.TestReadMatrix.test_read_fail_fread) ... ok
test_read_fail_malloc (__main__.TestReadMatrix.test_read_fail_malloc) ... ok
test_relu_invalid_n (__main__.TestRelu.test_relu_invalid_n) ... ok
test_relu_length_1 (__main__.TestRelu.test_relu_length_1) ... ok
test_relu_standard (__main__.TestRelu.test_relu_standard) ... ok
test_write_1 (__main__.TestWriteMatrix.test_write_1) ... ok
test_write_fail_fclose (__main__.TestWriteMatrix.test_write_fail_fclose) ... ok
test_write_fail_fopen (__main__.TestWriteMatrix.test_write_fail_fopen) ... ok
test_write_fail_fwrite (__main__.TestWriteMatrix.test_write_fail_fwrite) ... ok

----------------------------------------------------------------------
Ran 46 tests in 70.448s

OK
```

