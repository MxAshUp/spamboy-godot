extends Node

#Game Score
var score = 0 
#Elapsed Time on Level
var elapsedTime = 0



func _ready():
	randomize()

#Overwrite variables with defaults
func init():
	score = 0


#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)