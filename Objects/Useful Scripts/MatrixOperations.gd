extends Node

class_name MatrixOperations

# Copied basically from https://github.com/jpcerrone/PokeTetris
static func createMatrix(sizeX : int, sizeY : int) -> Array[Array]:
	var matrix : Array[Array]
	
	# Initializing
	for y in range(sizeY):
		var row : Array = []
		row.resize(sizeX)
		matrix.append(row)
	
	return matrix


static func clearRow(matrix : Array[Array], row : int):
	for x in range(matrix[row].size()):
		matrix[row][x] = 0


static func clearColumn(matrix : Array[Array], column : int):
	for y in range(matrix.size()):
		matrix[y][column] = 0
