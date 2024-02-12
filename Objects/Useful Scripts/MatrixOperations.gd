extends Node

class_name MatrixOperations




# Copied basically from https://github.com/jpcerrone/PokeTetris
static func createMatrix(sizeX : int, sizeY : int) -> Array[Array]:
	var matrix : Array[Array] = []
	
	for y in range(sizeY):
		var row : Array[int] = []
		row.resize(sizeX)
		row.fill(0)
		matrix.append(row)
	
	return matrix


static func createByteArray(sizeX : int, sizeY : int) -> PackedByteArray:
	var array : PackedByteArray = []
	
	array.resize(sizeX * sizeY)
	array.fill(0)
	
	return array

# Rotates clockwise only because math complicated so lazy
static func rotateMatrixClockwise(matrix : Array) -> Array[Array]:
	var size : Vector2i = Vector2i(matrix[0].size(), matrix.size())
	var newMatrix := MatrixOperations.createMatrix(size.y, size.x)
	
	for x in range(size.y):
		for y in range(size.x):
			# size.y - x - 1 because backwards for some reason (-1 = not out of bounds)
			newMatrix[y][x] = matrix[size.y - x - 1][y]
	
	return newMatrix
