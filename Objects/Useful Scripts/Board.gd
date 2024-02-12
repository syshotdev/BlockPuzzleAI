extends Node

class_name Board

const sizeX = 3
const sizeY = 3

var board : PackedByteArray
# Current thought is something like 
# It's a two dimentional array, with the color from an enum in GameColors every cell.

# Keys: Row/Column, Value: Color
var affectedRows : Dictionary
var affectedColumns : Dictionary



func _init(boardToCopyFrom : Board = null):
	# Guard clause
	if(boardToCopyFrom != null):
		board = boardToCopyFrom.board.duplicate()
		return
	
	# Creates an array of size Y and size X of integers
	board = MatrixOperations.createByteArray(sizeX, sizeY)


# Places the block on the top left corner, 
# aka pos = top left corner of block
func placeBlock(pos : Vector2i, block : Array):
	var size : Vector2i = Vector2(block[0].size(), block.size())
	
	for y in range(size.y):
		for x in range(size.x):
			# If the cell at coords == 0, don't place.
			if(block[y][x] == 0):
				continue
			
			setCellAt(pos.x + x, pos.y + y, 1)

# Updates and removes lines needing to be removed, and gives score :)
func updateBoard():
	# Arrays of values that need to be cleared
	var rowsToClear : PackedByteArray = []
	var columnsToClear : PackedByteArray = []
	
	for y in affectedRows.keys():
		if(isRowFull(y)):
			rowsToClear.append(y)
	
	for x in affectedColumns.keys():
		if(isColumnFull(x)):
			columnsToClear.append(x)
	
	for row in rowsToClear:
		clearRow(row)
	
	for column in columnsToClear:
		clearColumn(column)
	
	
	affectedRows.clear()
	affectedColumns.clear()

# Calculates the score without removing lines.
func calculateScore() -> float:
	var score : float = 0
	
	# Arrays of values that need to be cleared
	var rowsToClear : PackedByteArray = []
	var columnsToClear : PackedByteArray = []
	
	for y in affectedRows.keys():
		if(isRowFull(y)):
			rowsToClear.append(y)
	
	for x in affectedColumns.keys():
		if(isColumnFull(x)):
			columnsToClear.append(x)
	
	score += rowsToClear.size() * sizeY
	score += columnsToClear.size() * sizeX
	return score

# Checks if the block is placable at that place. (Top left = posStart.)
func isPlaceable(posToPlace : Vector2i, block : Array):
	var size : Vector2i = Vector2i(block[0].size(), block.size())
	
	# For each position in block array, check if board obstructs block with offset
	for y in range(size.y):
		for x in range(size.x):
			# If the cell from block at coords == 0, don't check to see if can place.
			if(block[y][x] == 0):
				continue
			
			# Offset by posToPlace, because that's where it needs to be placed
			if(getCellAt(x + posToPlace.x, y + posToPlace.y) != 0):
				return false
	
	return true

# Returns true or false if row is full (Full of non-zeros)
func isRowFull(y : int) -> bool:
	for x in range(sizeX):
		if(getCellAt(x, y) == 0):
			return false
	
	return true

# Returns true or false if column is full (Full of non-zeros)
func isColumnFull(x : int) -> bool:
	for y in range(sizeY):
		if(getCellAt(x, y) == 0):
			return false
	
	return true


func clearRow(row : int):
	for x in range(sizeX):
		setBareCell(x, row, 0)


func clearColumn(column : int):
	for y in range(sizeY):
		setBareCell(column, y, 0)


# Get the cell at position
func getCellAt(x : int, y : int):
	# 1D array but we act like it 2d
	var index : int = x + (y * sizeY)
	return board[index]

# Set cell at position with also recording what changed
func setCellAt(x : int, y : int, number : int):
	var index : int = x + (y * sizeY)
	board[index] = number
	
	# For efficiently clearing lines later
	affectedRows[y] = number
	affectedColumns[x] = number

# Sets a cell without all the random stuff
func setBareCell(x : int, y : int, number : int):
	var index : int = x + (y * sizeY)
	board[index] = number
