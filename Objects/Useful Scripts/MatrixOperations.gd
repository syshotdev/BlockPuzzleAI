extends Node

class_name MatrixOperations

enum numDegrees{
	ZERO,
	NINETY,
	ONE_HUNDRED_EIGHTY,
	TWO_HUNDRED_SEVENTY
}

# Copied basically from https://github.com/jpcerrone/PokeTetris
static func createMatrix(sizeX : int, sizeY : int) -> Array[Array]:
	var matrix : Array[Array]
	
	# Initializing
	for y in range(sizeY):
		var row : Array = []
		row.resize(sizeX)
		row.fill(0)
		matrix.append(row)
	
	return matrix

# Rotates clockwise only because math complicated so lazy
static func rotateMatrixClockwise(matrix : Array) -> Array[Array]:
	var size : Vector2i = Vector2(matrix[0].size(), matrix.size())
	var newMatrix := MatrixOperations.createMatrix(size.y, size.x)
	
	for x in range(size.y):
		for y in range(size.x):
			# size.y - x - 1 because backwards for some reason (-1 = not out of bounds)
			newMatrix[y][x] = matrix[size.y - x - 1][y]
	
	return newMatrix


static func clearRow(matrix : Array[Array], row : int):
	for x in range(matrix[row].size()):
		matrix[row][x] = 0


static func clearColumn(matrix : Array[Array], column : int):
	for y in range(matrix.size()):
		matrix[y][column] = 0
