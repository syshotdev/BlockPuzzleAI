extends Node

class_name GameColors

enum colors{ # Making sure not 0, because 0 is nothing.
	BLUE = 1, 
	LIGHT_BLUE = 2,
	GREEN = 3,
	YELLOW = 4,
	ORANGE = 5,
	RED = 6,
	PURPLE = 7,
}


static func getColorFromEnum(enumColor : colors) -> Color:
	var color : Color = Color.BLACK
	match enumColor:
		colors.BLUE:
			color = Color.DARK_BLUE
		colors.LIGHT_BLUE:
			color = Color.CORNFLOWER_BLUE
		colors.GREEN:
			color = Color.WEB_GREEN
		colors.LIGHT_BLUE:
			color = Color.CORNFLOWER_BLUE
		colors.YELLOW:
			color = Color.ORANGE
		colors.ORANGE:
			color = Color.ORANGE_RED
		colors.RED:
			color = Color.RED
		colors.PURPLE:
			color = Color.MEDIUM_VIOLET_RED
	
	return color
