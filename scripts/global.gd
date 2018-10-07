extends Node

enum GAMESTATE_ENUM { MAIN, CREDITS, GAME }

var gameState = MAIN

func _ready():
	randomize()
	
func init():
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)