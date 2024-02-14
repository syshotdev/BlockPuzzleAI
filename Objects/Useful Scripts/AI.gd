extends Node

class_name AI


# Minimum score that the search should look for.
# 0 fastest, INF slowest.
const pruneScore : float = 16

var blocks : Block

# How many time minmax
var pathsPruned : int = 0
var totalPaths : int = 0

func _init():
	blocks = Block.new() # Generate blocks with rotations

# maxMax but only with specified blocks in queue, instead of just trying all possible combinations.
func maxMaxBlocks(boardState : Board, alpha : float, blocksToUse : Array) -> float:
	# If depth reached, stop calculating.
	if(blocksToUse.size() <= 0):
		return boardState.calculateScore()
	
	boardState.updateBoard()
	
	var totalMoves : int = 0 # REMOVE LATER, FOR TESTING
	var bestScore := -INF
	# For each block, get moves from a block, and from blocksToUse remove that block (Because it's been used)
	for block in blocksToUse:
		var moves : Array[Move] = getMovesFromBlock(boardState, block)
		totalMoves += moves.size()
		var actualBlocksToUse : Array = blocksToUse.duplicate()
		actualBlocksToUse.erase(block)
		
		for move in moves:
			var board : Board = Board.new(boardState)
			board.placeBlock(move.boardPosition, move.block)
			var evaluationScore := maxMaxBlocks(board, alpha, actualBlocksToUse)
			
			board.free() # Prevent memory leak
			
			bestScore = max(evaluationScore, bestScore)
			alpha = max(evaluationScore, alpha)
			
			# FOR DEBUG
			totalPaths += moves.size()
			# If the score is above the prune score (basically minimum score), 
			# break and stop looking because we've found the score that's good enough
			if(pruneScore <= alpha):
				break
		
		for move in moves:
			move.free()
	
	if(totalMoves <= 0):
		push_warning("Moves possible are 0.")
	
	return bestScore

# Uses only the blocks provided to generate more positions/moves
func getPossibleMovesFromBlocks(boardState : Board, blocksToUse : Array) -> Array[Move]:
	var moves : Array[Move] = []
	
	for block in blocks.allBlocks:
		moves.append_array(getMovesFromBlock(boardState, block))
	
	return moves

# For one block, get every board that that block fits in.
func getMovesFromBlock(originBoard : Board, block : Array) -> Array[Move]:
	var moves : Array[Move] = []
	
	var blockSize = Vector2i(block[0].size(), block.size())
	var boardSize = Vector2i(originBoard.sizeX, originBoard.sizeY)
	# Offset the search by size, because we place top left corner and block size exists.
	var maxPos : Vector2i = (boardSize - blockSize) + Vector2i(1, 1)
	
	# From 0 to maxPos, every cell, check if can place and place block there.
	for y in range(maxPos.y):
		for x in range(maxPos.x):
			var actualPos := Vector2i(x, y)
			# If can't place block here don't make move.
			if(!originBoard.isPlaceable(actualPos, block)):
				continue
			
			# Create move and append to moves
			var move : Move = Move.new(actualPos, block)
			moves.append(move)
	
	return moves
