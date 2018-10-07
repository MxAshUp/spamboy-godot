extends Control

var level = preload("res://scenes/level.tscn")

onready var masterNode = get_parent()

var creditsActive = false
var active_level = null setget set_active_level

func setCameraActive():
	$Camera2D.make_current()

func _on_resumeBtn_button_down():
	if not creditsActive:
		masterNode.switchGameState(global.GAME)
		if active_level != null:
			active_level.unpause_level()

func set_active_level(new_active_level):
	
	if new_active_level == null:
		if active_level != null:
			active_level.queue_free()
		$vbox/resumegame.hide()
	else:
		new_active_level.connect("game_over", self, "level_finished")
		new_active_level.connect("paused", self, "level_paused")
		masterNode.add_child(new_active_level)
		$vbox/resumegame.show()

	active_level = new_active_level
	
func _on_newgameBtn_button_down():
	if not creditsActive:
		# in case there's already a level going, kill it
		set_active_level(null)
		#Instance level again
		active_level = level.instance()
		# todo, set objections based on something else. Hard, easy mode?
		active_level.objective_spam_count = 30
		active_level.objective_seconds = 5
		set_active_level(active_level)
		masterNode.switchGameState(global.GAME)

func level_finished(finished_level, score):
	masterNode.switchGameState(global.MAIN)
	set_active_level(null)

func level_paused(paused_level):
	print("PASUED")
	masterNode.switchGameState(global.MAIN)
	paused_level.hide()

func _on_creditsBtn_button_down():
	if not creditsActive:
		creditsActive = true
		$credits.show()

func _on_quitBtn_button_down():
	if not creditsActive:
		get_tree().quit()

func _on_backBtn_button_down():
	if creditsActive:
		creditsActive = false
		$credits.hide()
