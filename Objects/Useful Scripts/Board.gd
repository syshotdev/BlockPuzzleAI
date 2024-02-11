extends Node

class_name Board

const sizeX = 3
const sizeY = 3

var board : Array
# Current thought is something like 
# It's a two dimentional array, with the color from an enum in GameColors every cell.

# Keys: Row/Column, Value: Coloriqhrslkfdatvuhgfufiyfvxs,kkgljycc
var affectedRows : Dictionary
var affectedColumns : Dictionary



func _init(boardToCopyFrom : Board = null):
	# Guard clause
	if(boardToCopyFrom != null):
		board = boardToCopyFrom.board.duplicate(true)
		return
	
	# Creates an array of size Y and size X of integers
	board = MatrixOperations.createMatrix(sizeX, sizeY)


# Updates and removes lines needing to be removed
func updateBoard():
	# Arrays of values that need to be cleared
	var rowsToClear : Array[int]
	var columnsToClear : Array[int]
	
	for y in affectedRows.keys():
		if(isRowFull(y)):
			rowsToClear.append(y)
	
	for x in affectedColumns.keys():
		if(isColumnFull(x)):
			columnsToClear.append(x)
	
	for row in rowsToClear:
		MatrixOperations.clearRow(board, row)
	
	for column in columnsToClear:
		MatrixOperations.clearColumn(board, column)
	
	
	affectedRows.clear()
	affectedColumns.clear()

# Returns true or false if row is full (Full of non-zeros)
func isRowFull(y : int) -> bool:
	for x in range(sizeX):
		if(board[y][x] == 0):
			return false
	
	return true

# Returns true or false if column is full (Full of non-zeros)
func isColumnFull(x : int) -> bool:
	for y in range(sizeY):
		if(board[y][x] == 0):
			return false
	
	return true

# Get the cell at position
func getCellAt(x : int, y : int):
	return board[y][x]

# Get the cell at position
func setCellAt(x : int, y : int, number : int):
	board[y][x] = number
	
	# For efficiently clearing lines later
	affectedRows[y] = number
	affectedColumns[x] = number