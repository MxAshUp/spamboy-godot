extends Control

var level = preload("res://scenes/level.tscn")

onready var masterNode = get_parent()

var creditsActive = false
var active_level = null setget set_active_level

func setCameraActive():
	$Camera2D.make_current()

func unpause_active_level():
	if active_level != null and active_level.level_active:
		hide()
		active_level.unpause_level()

func _on_resumeBtn_button_down():
	if not creditsActive:
		$clickSound.play()
		unpause_active_level()

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if not creditsActive:
			unpause_active_level()

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
		active_level.objective_seconds = 2
		set_active_level(active_level)
		hide()
		$clickSound.play()

func level_finished(finished_level, score):
	show()
	set_active_level(null)

func level_paused(paused_level):
	show()
	paused_level.hide()
	setCameraActive()

func _on_creditsBtn_button_down():
	if not creditsActive:
		creditsActive = true
		$credits.show()
		$clickSound.play()

func _on_quitBtn_button_down():
	if not creditsActive:
		$clickSound.play()
		get_tree().quit()

func _on_backBtn_button_down():
	if creditsActive:
		creditsActive = false
		$credits.hide()
		$clickSound.play()
