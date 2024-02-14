extends Node

class_name AI


# Minimum score that the search should look for.
# 0 fastest, INF slowest.
const pruneScore : float = 16

# How many time minmax
var pathsPruned : int = 0
var totalPaths : int = 0



# maxMax but only with specified blocks in queue, instead of just trying all possible combinations.
func maxMaxBlocks(boardState : Board, alpha : float, blocksToUse : Array) -> float:
	# If depth reached, stop calculating.
	if(blocksToUse.size() <= 0):
		return boardState.calculateScore()
	
	boardState.updateBoard()
	
	var bestScore := -INF
	# For each block, get moves from a block, and from blocksToUse remove that block (Because it's been used)
	for block in blocksToUse:
		var moves : Array[Move] = getMovesFromBlock(boardState, block)
		var actualBlocksToUse : Array = blocksToUse.duplicate()
		actualBlocksToUse.erase(block)
		
		for move in moves:
			var board : Board = Board.new(boardState)
			board.placeBlock(move.boardPosition, move.block)
			var evaluationScore := maxMaxBlocks(board, alpha, actualBlocksToUse)
			
			bestScore = max(evaluationScore, bestScore)
			alpha = max(evaluationScore, alpha)
			
			# FOR DEBUG
			totalPaths += moves.size()
			# If the score is above the prune score (basically minimum score), 
			# break and stop looking because we've found the score that's good enough
			if(pruneScore <= alpha):
				break
	
	return bestScore


# Minimax but only maxxing score
# Might remove this in future because currently not using and just hassle to refactor
func maxMax(boardState : Board, alpha : float, depth : int) -> float:
	# If depth reached, stop calculating.
	if(depth <= 0):
		return boardState.calculateScore()
	
	boardState.updateBoard()
	
	# Get all moves.
	var moves := getPossibleMovesFromBlocks(boardState, blocks.blockTypes)
	
	var bestScore := -INF
	# For each move, find the best score.
	for i in range(moves.size()):
		var move := moves[i]
		
		var generatedBoard : Board = Board.new(boardState).placeBlock(move.boardPosition, move.block)
		var evaluationScore := maxMax(generatedBoard, alpha, depth - 1)
		generatedBoard.free() # Free so no memory leak
		
		bestScore = max(evaluationScore, bestScore)
		alpha = max(evaluationScore, alpha)
		
		# FOR DEBUG
		totalPaths += moves.size()
		
		# If the score is above the prune score (basically minimum score), 
		# break and stop looking because we've found the score that's good enough
		if(pruneScore <= alpha):
			pathsPruned += moves.size() - i
			break
	
	for move in moves:
		move.free()
	
	return bestScore

# Uses only the blocks provided to generate more positions/moves
func getPossibleMovesFromBlocks(boardState : Board, blocksToUse : Array) -> Array[Move]:
	var moves : Array[Move] = []
	
	for key in blocksToUse:
		for block in blocks.rotatedBlocks[key]:
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
