extends Node2D

class_name Map

@export var colorGrid : GridContainer

@onready var ai : AI = AI.new()

var blocksRemaining : Array = []


func getNextBlocks(number : int) -> Array:
	var blocksToReturn : Array = []
	for i in range(number): # Get x blocks
		blocksToReturn.append(ai.blocks.allBlocks.pick_random())
	
	return blocksToReturn


# Function to find best AI move from a certain list of blocks (Fit them in correctly)
func calculateAIBestMove(boardState : Board, blocksToUse : Array) -> Move:
	var bestMove : Move = Move.new(Vector2i(0,0), blocksToUse[0])
	var bestScore : float = -INF
	
	# For every block, find which block is best for board.
	for block in blocksToUse:
		# Remove the block we just used (I duplicated this code from AI script)
		var blocksInOrder : Array = blocksToUse.duplicate()
		blocksInOrder.erase(block)
		
		# For every board that this block generates, find best one.
		for move in ai.getMovesFromBlock(boardState, block):
			var board := Board.new(boardState)
			board.placeBlock(move.boardPosition, move.block) # Create board and place move
			
			var score := ai.maxMaxBlocks(board, -INF, blocksInOrder)
			board.free() # Prevent memory leak
			
			if(score > bestScore):
				bestMove = Move.new(move.boardPosition, move.block) # Because .duplicate doesn't work
				bestScore = score
			
			move.free()
	
	blocksRemaining.erase(bestMove.block) # Remove things from blocks remaining when things
	
	return bestMove

# For displaying the board
func calculateGridOfColorRect(board : Board):
	# Remove children (to prevent memory leak)
	for child in colorGrid.get_children():
		child.queue_free()
	
	colorGrid.columns = board.sizeX
	
	# For every row and cell, get cell and check if 0.
	# Then add to colorGrid
	for row in range(board.sizeY):
		for cell in range(board.sizeX):
			var number = board.getCellAt(cell, row)
			
			var color = GameColors.getColorFromEnum(number) # Number == enum
			
			var colorRect = createColorRect(Vector2(16,16), color)
			colorGrid.add_child(colorRect)


func createColorRect(size : Vector2, color : Color) -> ColorRect:
	var colorRect := ColorRect.new()
	colorRect.color = color
	colorRect.custom_minimum_size = size
	colorRect.visible = true
	return colorRect
