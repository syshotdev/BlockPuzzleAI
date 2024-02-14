extends Node2D

@onready var ai : AI = AI.new()
@onready var mainBoard : Board = Board.new()
@export var colorGrid : GridContainer

func _ready():
	mainBoard.placeBlock(Vector2i(2,2), Block.shape_1x1)
	var blocksInQueue : Array = [Block.shape_3x3,Block.shape_3x3,Block.shape_2x2]
	
	# Blocks that are remaining in the queue (workaround for weird bug)
	var blocksRemaining : Array = blocksInQueue.duplicate() 
	
	for block in blocksInQueue:
		# Keep adding to the main board till blocks end
		var move := calculateAIBestMove(mainBoard, blocksRemaining)
		mainBoard.placeBlock(move.boardPosition, move.block)
		blocksRemaining.erase(block)
		#mainBoard.updateBoard()
	
	calculateGridOfColorRect(mainBoard)


# Function to find best AI board from a certain list of blocks (Fit them in correctly)
func calculateAIBestMove(boardState : Board, blocksToUse : Array) -> Move:
	var bestMove : Move = null
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
			
			if(score > bestScore):
				bestMove = move
				bestScore = score
	
	return bestMove


func calculateGridOfColorRect(board : Board):
	# Remove children
	for child in colorGrid.get_children():
		child.queue_free()
	
	colorGrid.columns = board.sizeX
	
	# Init color with default color
	var color : Color = Color(0,0,0,1)
	
	# For every row and cell, get cell and check if 0.
	# Then add to colorGrid
	for row in range(board.sizeY):
		for cell in range(board.sizeX):
			var number = board.getCellAt(cell, row)
			
			# If number empty, show nothing, else show something
			if(number == 0):
				color = Color(0,0,0,1)
			else:
				color = Color.CORNFLOWER_BLUE
			
			var colorRect = createColorRect(Vector2(16,16), color)
			colorGrid.add_child(colorRect)


func createColorRect(size : Vector2, color : Color) -> ColorRect:
	var colorRect := ColorRect.new()
	colorRect.color = color
	colorRect.custom_minimum_size = size
	colorRect.visible = true
	return colorRect
