extends Node

class_name AI

var board : Board
var blocks : Block

func _init():
	board = Board.new()
	blocks = Block.new()
	
	var memory_before = OS.get_static_memory_usage()
	var boards := getPossibleBoards(board)
	var memory_used = OS.get_static_memory_usage() - memory_before
	print(memory_used)
	print("Boards:" + str(boards.size()))


func getPossibleBoards(boardState : Board) -> Array[Board]:
	var boards : Array[Board] = []
	
	for key in blocks.rotatedBlocks.keys():
		for block in blocks.rotatedBlocks[key]:
			boards.append_array(getBoardsFromBlock(boardState, block))
	
	return boards


func getBoardsFromBlock(originBoard : Board, block : Array) -> Array[Board]:
	var boards : Array[Board] = []
	
	var blockSize = Vector2i(block[0].size(), block.size())
	var boardSize = Vector2i(board.board[0].size(), board.board.size())
	# Offset the search by size, because we place top left corner and block size exists.
	var maxPos : Vector2i = (boardSize - blockSize)
	
	# From 0 to maxPos, every cell, check if can place and place block there.
	for y in range(maxPos.y):
		for x in range(maxPos.x):
			# Exists because arrays start at 0
			var actualPos := Vector2i(x, y) #- Vector2i(1, 1)
			# If can't place block here don't append new board.
			if(!originBoard.isPlaceable(actualPos, block)):
				continue
			
			# Create board and place block
			var newBoard : Board = Board.new(originBoard)
			newBoard.placeBlock(actualPos, block)
			boards.append(newBoard)
	
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
