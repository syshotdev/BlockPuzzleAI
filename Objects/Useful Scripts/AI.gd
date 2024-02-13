extends Node

class_name AI


# Minimum score that the search should look for.
const pruneScore : float = INF

var mainBoard : Board
var blocks : Block

# How many time minmax
var pathsPruned : int = 0
var totalPaths : int = 0

func _init():
	mainBoard = Board.new()
	blocks = Block.new()
	
	var memory_before = OS.get_static_memory_usage()
	var score := maxMaxBlocks(mainBoard, -INF, [Block.shape_3x3,Block.shape_3x3,Block.shape_2x2])
	var memory_used : float = OS.get_static_memory_usage() - memory_before
	memory_used = memory_used / 1000 / 1000
	print(str(memory_used) + " Mb")
	print(score)
	print(str(pathsPruned) + " Paths Pruned, " + str(totalPaths) + " Total Paths")


# maxMax but only with specified blocks in queue, instead of just trying all possible combinations.
func maxMaxBlocks(boardState : Board, alpha : float, blocksToUse : Array) -> float:
	# If depth reached, stop calculating.
	if(blocksToUse.size() <= 0):
		return boardState.calculateScore()
	
	boardState.updateBoard()
	
	
	var bestScore := -INF
	# For each block, get boards from a block and blocksToUse without that block (Because it's been used)
	for block in blocksToUse:
		
		var boards : Array[Board] = getBoardsFromBlock(boardState, block)
		var actualBlocksToUse : Array = blocksToUse.duplicate()
		actualBlocksToUse.erase(block)
		
		for board in boards:
			var evaluationScore := maxMaxBlocks(board, alpha, actualBlocksToUse)
			
			bestScore = max(evaluationScore, bestScore)
			alpha = max(evaluationScore, alpha)
			
			# FOR DEBUG
			totalPaths += boards.size()
			# If the score is above the prune score (basically minimum score), 
			# break and stop looking because we've found the score that's good enough
			if(pruneScore <= alpha):
				break
	
	return bestScore


# Minimax but only maxxing score
func maxMax(boardState : Board, alpha : float, depth : int) -> float:
	# If depth reached, stop calculating.
	if(depth <= 0):
		return boardState.calculateScore()
	
	boardState.updateBoard()
	
	# Get all boards.
	var boards := getPossibleBoards(boardState)
	
	var bestScore := -INF
	# For each board, find the best score.
	for i in range(boards.size()):
		var board := boards[i]
		var evaluationScore := maxMax(board, alpha, depth - 1)
		
		bestScore = max(evaluationScore, bestScore)
		alpha = max(evaluationScore, alpha)
		
		# FOR DEBUG
		totalPaths += boards.size()
		
		# If the score is above the prune score (basically minimum score), 
		# break and stop looking because we've found the score that's good enough
		if(pruneScore <= alpha):
			pathsPruned += boards.size() - i
			break
	
	for board in boards:
		board.free()
	
	return bestScore

# Uses only the blocks provided to generate more positions/board states
func getPossibleBoardsFromBlocks(boardState : Board, blocksToUse : Array) -> Array[Board]:
	var boards : Array[Board] = []
	
	for key in blocksToUse:
		for block in blocks.rotatedBlocks[key]:
			boards.append_array(getBoardsFromBlock(boardState, block))
	
	return boards

# Gets ALL of the possible blocks in a specified board state
func getPossibleBoards(boardState : Board) -> Array[Board]:
	var boards : Array[Board] = []
	
	for key in blocks.rotatedBlocks.keys():
		for block in blocks.rotatedBlocks[key]:
			boards.append_array(getBoardsFromBlock(boardState, block))
	
	return boards

# For one block, get every board that that block fits in.
func getBoardsFromBlock(originBoard : Board, block : Array) -> Array[Board]:
	var boards : Array[Board] = []
	
	var blockSize = Vector2i(block[0].size(), block.size())
	var boardSize = Vector2i(originBoard.sizeX, originBoard.sizeY)
	# Offset the search by size, because we place top left corner and block size exists.
	var maxPos : Vector2i = (boardSize - blockSize) + Vector2i(1, 1)
	
	# From 0 to maxPos, every cell, check if can place and place block there.
	for y in range(maxPos.y):
		for x in range(maxPos.x):
			var actualPos := Vector2i(x, y)
			# If can't place block here don't append new board.
			if(!originBoard.isPlaceable(actualPos, block)):
				continue
			
			# Create board and place block
			var newBoard : Board = Board.new(originBoard)
			newBoard.placeBlock(actualPos, block)
			boards.append(newBoard)
	
	return boards
