extends Node2D

class_name Map

@export var colorGrid : GridContainer
@export var blockGrids : VBoxContainer

@onready var ai : AI = AI.new()

var blocksRemaining : Array = []


func getNextBlocks(number : int) -> Array:
	var blocksToReturn : Array = []
	for i in range(number): # Get x blocks
		blocksToReturn.append(ai.blocks.allBlocks.pick_random())
	
	for child in blockGrids.get_children():
		child.queue_free()
	
	
	for block in blocksToReturn:
		var blockGrid := calculateBlockGrid(block) # MAKE BLOCKS 5x5 SQUARES
		blockGrids.add_child(blockGrid)
		blockGrids.add_spacer(false)
	
	
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
			var number : int = board.getCellAt(cell, row)
			
			var color = GameColors.getColorFromEnum(number) # Number == enum
			var colorRect := createColorRect(Vector2(16,16), color)
			colorGrid.add_child(colorRect)

# Displaying the next moves
func calculateBlockGrid(block : Array) -> GridContainer:
	var container : GridContainer = GridContainer.new()
	container.columns = block[0].size()
	
	# For every cell in block,
	for row in range(block.size()):
		for cell in range(block[0].size()):
			var number : int = block[row][cell]
			
			var color = GameColors.getColorFromEnum(number) # Number == enum
			var colorRect := createColorRect(Vector2(16,16), color)
			container.add_child(colorRect)
	
	return container


func createColorRect(size : Vector2, color : Color) -> ColorRect:
	var colorRect := ColorRect.new()
	colorRect.color = color
	colorRect.custom_minimum_size = size
	colorRect.visible = true
	return colorRect
