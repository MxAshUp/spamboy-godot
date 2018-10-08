extends Control

const levels = [
	"res://scenes/levels/level-1.tscn",
	"res://scenes/levels/level-2.tscn",
	"res://scenes/levels/level-3.tscn",
	"res://scenes/levels/level-4.tscn",
	"res://scenes/levels/level-5.tscn",
	# simply add more here
]

var scores = []

var current_level = 0

onready var masterNode = get_parent()

var creditsActive = false
var active_level = null setget set_active_level

func setCameraActive():
	$Camera2D.make_current()

func unpause_active_level():
	if active_level != null:
		if active_level.level_active:
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
		new_active_level.connect("next_level", self, "next_level")
		new_active_level.connect("retry_level", self, "retry_level")
		new_active_level.connect("paused", self, "level_paused")
		masterNode.add_child(new_active_level)
		$vbox/resumegame.show()

	active_level = new_active_level
	
func _on_newgameBtn_button_down():
	if not creditsActive:
		initial_current_level()
		$clickSound.play()

func initial_current_level():
		# in case there's already a level going, kill it
		set_active_level(null)
		var levelObject = load(levels[current_level])
		#Instance level again
		active_level = levelObject.instance()
		# todo, set objections based on something else. Hard, easy mode?
		set_active_level(active_level)
		hide()
		
func level_finished(finished_level, score):
	if scores.size() == 5:
		$scores/vbox/label1/points.set_text(str(scores[0]))
		$scores/vbox/label2/points.set_text(str(scores[1]))
		$scores/vbox/label3/points.set_text(str(scores[2]))
		$scores/vbox/label4/points.set_text(str(scores[3]))
		$scores/vbox/label5/points.set_text(str(scores[4]))
		$scores/vbox/label6/points.set_text(str(scores[0]+scores[1]+scores[2]+scores[3]+scores[4]))
		$scores.show()
	
	self.show()
	
	current_level = 0
	set_active_level(null)
	
func next_level(finished_level, score):
	scores.append(float(int(score * 1000))/1000)
	current_level += 1
	if current_level >= levels.size():
		# game complete!
		# todo - end screen
		level_finished(finished_level, score)
	else:
		initial_current_level()
	
func retry_level(finished_level):
	initial_current_level()

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
