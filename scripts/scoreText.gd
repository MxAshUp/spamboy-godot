extends Node2D

export (String) var text = "" setget setText
export (String, "spawn_a", "spawn_b") var animation = "spawn_a"
export (Color) var text_color = Color(255, 255, 255)

func _ready():
	$AnimationPlayer.play(animation)
	$container/text.add_color_override("font_color", text_color)

func setText(new_text):
	if $container/text:
		$container/text.text = new_text
	if $container/shadow:
		$container/shadow.text = new_text
	text = new_text

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
