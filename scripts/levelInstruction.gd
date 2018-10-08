extends CanvasLayer

export(String) var text = "Hey! Need you to deliver 20 flyers in 25 seconds!\n\nPs. take the bike"

func _ready():
	get_tree().set_pause(true)
	$text.parse_bbcode(text)

func _input(event):
	if event.is_action_pressed("ui_select") and $AnimationPlayer.get_current_animation() != "idle":
		queue_free()
