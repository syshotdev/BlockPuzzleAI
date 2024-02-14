extends Node2D

@onready var mainBoard : Board = Board.new()
@onready var map : Map = $Map

func _input(event):
	if(Input.is_action_just_pressed("ui_right")):
		renewMapBlocks()
		stepMap()


func renewMapBlocks():
	if(map.blocksRemaining.size() <= 0):
		map.blocksRemaining = map.getNextBlocks(3)


func stepMap():
	mainBoard.updateBoard() # Updating first so we can see what AI is generating
	
	if(map.ai.isTerminatingState(mainBoard, map.blocksRemaining)):
		printerr("GAME ENDED!")
		return
	
	
	var move : Move = map.calculateAIBestMove(mainBoard, map.blocksRemaining)
	mainBoard.placeBlock(move.boardPosition, move.block)
	move.free() # Prevent memory leak
	map.calculateGridOfColorRect(mainBoard)
