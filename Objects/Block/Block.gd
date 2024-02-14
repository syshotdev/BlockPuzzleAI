extends Node2D

class_name Block

var shape_1x1 := [
	[1]]
var shape_2x2 := [
	[1,1],
	[1,1]]
var shape_2x3 := [
	[1,1],
	[1,1],
	[1,1]]
var shape_3x3 := [
	[1,1,1],
	[1,1,1],
	[1,1,1]]
var shape_L := [
	[1,0],
	[1,0],
	[1,1]]
var shape_perfectL := [
	[1,0,0],
	[1,0,0],
	[1,1,1]] # Shape is L but both sides are equal
var shape_smallL := [
	[1,0],
	[1,1]] # Shape is L but both sides are equal
var shape_T := [
	[1,1,1],
	[0,1,0]]
var shape_Ix2 := [
	[1,1]]
var shape_Ix3 := [
	[1,1,1]]
var shape_Ix4 := [
	[1,1,1,1]]
var shape_Ix5 := [
	[1,1,1,1,1]]
var shape_Z := [
	[0,1],
	[1,1],
	[1,0]]
var shape_S := [
	[1,0],
	[1,1],
	[0,1]]


var blockTypes = [
	shape_1x1,
	shape_2x2,
	shape_2x3,
	shape_3x3,
	shape_perfectL,
	shape_smallL,
	shape_L,
	shape_T,
	shape_Z,
	shape_S,
	shape_Ix3,
	shape_Ix4,
	shape_Ix5
	]


var rotatedBlocks : Dictionary # Key: Const block, Value: Array of all rotated blocks (NO DUPLICATES)
var allBlocks : Array # Array of every single block


func _init():
	calculateRotatedBlocks()
	genBlockColors()


# Gives each seperate block a color
func genBlockColors():
	for block in allBlocks:
		var color : GameColors.colors = GameColors.colors.values().pick_random()
		setBlockColor(block, color)


func setBlockColor(block : Array, color : GameColors.colors):
	for y in block.size():
		for x in block[0].size():
			
			if (block[y][x] == 0): # Don't give 0 a random color
				continue
			
			block[y][x] = color # Else set to color


# Calculates the rotated blocks for each block, and gets rid of duplicates.
func calculateRotatedBlocks():
	for block in blockTypes:
		# Array of blocks to be put into rotatedBlocks
		var blockRotateds := genRotatedBlocks(block)
		rotatedBlocks[block] = blockRotateds
		allBlocks.append_array(blockRotateds)



func genRotatedBlocks(block : Array) -> Array[Array]:
	var blockRotateds : Array[Array] = []
	var lastBlock : Array = block
	
	# Append the original block (Because it is a block)
	blockRotateds.append(block)
	
	for i in range(3):
		var rotatedBlock := MatrixOperations.rotateMatrixClockwise(lastBlock)
		
		# If block array doesn't have block, then add it.
		if(!blockRotateds.has(rotatedBlock)):
			blockRotateds.append(rotatedBlock)
			lastBlock = rotatedBlock # Set the last block
	
	return blockRotateds
