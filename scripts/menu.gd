extends Control

var level = preload("res://scenes/level.tscn")

onready var masterNode = get_parent()

var creditsActive = false

func setCameraActive():
	$Camera2D.make_current()

func _on_resumeBtn_button_down():
	if not creditsActive:
		masterNode.switchGameState(global.GAME)

func _on_newgameBtn_button_down():
	if not creditsActive:
		#Remove level
		masterNode.remove_child(masterNode.get_node("level"))
		#Instance level again
		var thisLevel = level.instance()
		# todo, set objections based on something else. Hard, easy mode?
		thisLevel.objective_spam_count = 30
		thisLevel.objective_seconds = 120
		# TODO - maybe masterNode should listen instead
		thisLevel.connect("game_over", self, "level_finished")
		$vbox/resumegame.show()
		masterNode.add_child(thisLevel)
		masterNode.switchGameState(global.GAME)

func level_finished():
	pass

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
