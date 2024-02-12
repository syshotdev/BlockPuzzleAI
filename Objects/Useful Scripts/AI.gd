extends Node

@onready var board : Board = Board.new()
@onready var blocks : Block = Block.new() # Generate the blocks

func _ready():
	placeBlock(Vector2i(0,0), Block.shape_3x3)


func getPossibleBoards(boardState : Board) -> Array[Board]:
	var boards : Array[Board] = []
	
	for key in blocks.rotatedBlocks.keys():
		for block in blocks.rotatedBlocks[key]:
			
			var blockSize = Vector2i(block[0].size(), block.size())
			var boardSize = Vector2i(board.board[0].size(), board.board.size())
			# Offset the search by size, because we place top left corner and block size exists.
			var maxPos : Vector2i = boardSize - blockSize
			
			for y in range(maxPos.y):
				for x in range(maxPos.x):
					if(isPlaceable(Vector2i(x, y), block)):
						var newBoard : Board = Board.new(boardState)
						boards.append(newBoard) # Lol 6 INDENTATIONS!!!
	
	return boards


# Places the block on the top left corner, 
# aka pos = top left corner of block
func placeBlock(pos : Vector2i, block : Array):
	var size : Vector2i = Vector2(block[0].size(), block.size())
	var center : Vector2 = size/2
	
	if(!isPlaceable(pos, block)):
		return false
	
	for y in range(pos.y, size.y + pos.y):
		for x in range(pos.x, size.x + pos.x):
			# If the cell at coords == 0, don't place.
			if(block[y][x] == 0):
				continue
			
			board.setCellAt(x, y, 1)
	
	return true


# Checks if the block is placable at that place. (Top left = posStart.)
func isPlaceable(posStart : Vector2i, block : Array):
	var size : Vector2i = Vector2(block[0].size(), block.size())
	var posEnd : Vector2i = posStart + size
	
	# For each position, check if board obstructs block.
	# Range from pos start to pos end.
	for y in range(posStart.y, posEnd.y):
		for x in range(posStart.x, posEnd.x):
			# If the cell at coords == 0, don't check to see if can place.
			if(block[y][x] == 0):
				continue
			
			if(board.getCellAt(x, y) != 0):
				return false
	
	return true
