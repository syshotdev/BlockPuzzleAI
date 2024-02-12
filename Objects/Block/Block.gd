extends Node2D

class_name Block

const shape_1x1 := [
	[1]]
const shape_2x2 := [
	[1,1],
	[1,1]]
const shape_3x3 := [
	[1,1,1],
	[1,1,1],
	[1,1,1]]
const shape_L := [
	[1,0],
	[1,0],
	[1,1]]
const shape_perfectL := [
	[1,0,0],
	[1,0,0],
	[1,1,1]] # Shape is L but both sides are equal
const shape_T := [
	[1,1,1],
	[0,1,0]]
const shape_Ix3 := [
	[1,1,1]]
const shape_Ix4 := [
	[1,1,1,1]]
const shape_Ix5 := [
	[1,1,1,1,1]]
const shape_Z := [
	[0,1],
	[1,1],
	[1,0]]
const shape_S := [
	[1,0],
	[1,1],
	[0,1]]


var blockTypes = [
	shape_1x1,
	shape_2x2,
	shape_3x3,
	shape_perfectL,
	shape_L,
	shape_T,
	shape_Z,
	shape_S,
	shape_Ix3,
	shape_Ix4,
	shape_Ix5]


var rotatedBlocks : Dictionary # Key: Const block, Value: Array of all rotated blocks (NO DUPLICATES)


func _init():
	calculateRotatedBlocks()


func calculateRotatedBlocks():
	for block in blockTypes:
		# Array of blocks to be put into rotatedBlocks
		var blockRotateds : Array
		var lastBlock : Array = block
		
		
		for i in range(3):
			var rotatedBlock := MatrixOperations.rotateMatrixClockwise(lastBlock)
			if(rotatedBlock != lastBlock):
				blockRotateds.append(rotatedBlock)
				lastBlock = rotatedBlock # Set the last block
		
		# Append the original block (Because it is a block)
		blockRotateds.append(block)
		
		rotatedBlocks[block] = blockRotateds
