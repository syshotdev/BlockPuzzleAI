extends Node2D

class_name Block

const shape_1x1 = [1]
const shape_2x2 = [
	[1,1],
	[1,1]]
const shape_3x3 = [
	[1,1,1],
	[1,1,1],
	[1,1,1]]
const shape_L = [
	[1,0],
	[1,0],
	[1,1]]
const shape_perfectL = [
	[1,0,0],
	[1,0,0],
	[1,1,1]] # Shape is L but both sides are equal
const shape_T = [
	[1,1,1],
	[0,1,0]]
const shape_Ix3 = [
	[1,1,1]]
const shape_Ix4 = [
	[1,1,1,1]]
const shape_Ix5 = [
	[1,1,1,1,1]]
const shape_Z = [
	[0,1],
	[1,1],
	[1,0]] # Will flip later
