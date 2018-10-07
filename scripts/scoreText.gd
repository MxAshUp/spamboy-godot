extends Node2D

export (String) var text = "" setget setText
export (String, "spawn_a", "spawn_b") var animation = "spawn_a"

func _ready():
	$AnimationPlayer.play(animation)

func setText(new_text):
	if $container/text:
		$container/text.text = new_text
	if $container/shadow:
		$container/shadow.text = new_text
	text = new_text

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
