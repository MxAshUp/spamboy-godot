extends CanvasLayer

export(String) var text = "Hey! Need you to deliver 20 flyers in 25 seconds!\n\nPs. take the bike"


func _ready():
	$text.parse_bbcode(text)
	#get_parent().pause_level()

func _input(event):
	if event.is_action_pressed("ui_select") and $AnimationPlayer.get_current_animation() != "idle":
		get_parent().unpause_level()
		queue_free()

#TODO pause was constantly overwritten, so I've added this hack
func _process(delta):
	get_tree().paused = true