extends Node

class_name Move

# Class exists because I can't find out how to GET THE MOVE FROM THE AI
# The ai is useless if I can't get the move, so I'm just making a new move class
var boardPosition : Vector2i = Vector2i.ZERO
var block : Array = []

# Init function for usablility
func _init(position : Vector2i, block : Array):
	boardPosition = position
	self.block = block
