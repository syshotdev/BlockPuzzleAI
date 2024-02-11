extends Node2D

@onready var board : Board = Board.new()

func _ready():
	placeBlock(Vector2i(0,0), Block.shape_3x3)

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
	pass
