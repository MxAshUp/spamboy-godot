extends Node

signal paused
signal game_over
signal next_level
signal retry_level

var level_active setget ,get_level_active

func _ready():
	$level.connect("game_over", self, "game_over")
	$level.connect("next_level", self, "next_level")
	$level.connect("retry_level", self, "retry_level")
	$level.connect("paused", self, "paused")
	
func paused(object):
	emit_signal("paused", object)
	
func game_over(object, final_score):
	emit_signal("game_over", object, final_score)
	
func retry_level(object):
	emit_signal("retry_level", object)
	
func next_level(object, final_score):
	emit_signal("next_level", object, final_score)
	
func unpause_level():
	$level.unpause_level()
	
func get_level_active():
	return $level.level_active