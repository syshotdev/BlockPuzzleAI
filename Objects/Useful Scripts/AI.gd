extends Node

class_name AI

var board : Board
var blocks : Block

func _init():
	board = Board.new()
	blocks = Block.new()
	
	var memory_before = OS.get_static_memory_usage()
	var score := maxmax(board, 2)
	var memory_used : float = OS.get_static_memory_usage() - memory_before
	memory_used = memory_used / 1000 / 1000
	print(str(memory_used) + " Mb")
	print(score)

# Minimax but only maxxing score
func maxmax(boardState : Board, depth : int) -> int:
	# If depth reached, stop calculating.
	if(depth <= 0):
		return boardState.updateBoard()
	
	
	# Get all boards.
	var boards := getPossibleBoards(boardState)
	
	var bestScore := -INF
	for board in boards:
		var thisBoardScore := maxmax(board, depth - 1)
		
		# Get best board
		if(thisBoardScore > bestScore):
			bestScore = thisBoardScore
		
		board.queue_free()
	
	return bestScore


func getPossibleBoards(boardState : Board) -> Array[Board]:
	var boards : Array[Board] = []
	
	for key in blocks.rotatedBlocks.keys():
		for block in blocks.rotatedBlocks[key]:
			boards.append_array(getBoardsFromBlock(boardState, block))
	
	return boards


func getBoardsFromBlock(originBoard : Board, block : Array) -> Array[Board]:
	var boards : Array[Board] = []
	
	var blockSize = Vector2i(block[0].size(), block.size())
	var boardSize = Vector2i(board.sizeX, board.sizeY)
	# Offset the search by size, because we place top left corner and block size exists.
	var maxPos : Vector2i = (boardSize - blockSize)
	
	# From 0 to maxPos, every cell, check if can place and place block there.
	for y in range(maxPos.y):
		for x in range(maxPos.x):
			var actualPos := Vector2i(x, y) #- Vector2i(1, 1)
			# If can't place block here don't append new board.
			if(!originBoard.isPlaceable(actualPos, block)):
				continue
			
			# Create board and place block
			var newBoard : Board = Board.new(originBoard)
			newBoard.placeBlock(actualPos, block)
			boards.append(newBoard)
	
	return boards
