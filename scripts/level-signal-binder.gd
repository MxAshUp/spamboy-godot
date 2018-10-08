extends Node

signal paused
signal game_over

var level_active setget ,get_level_active

func _ready():
	$level.connect("game_over", self, "game_over")
	$level.connect("paused", self, "paused")
	
func paused(object):
	emit_signal("paused", object)
	
func game_over(object, final_score):
	emit_signal("game_over", object, final_score)
	
func unpause_level():
	$level.unpause_level()
	
func get_level_active():
	return $level.level_active