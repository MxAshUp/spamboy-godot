extends Node2D


export(Texture) var obstacle = preload("res://assets/level/granny.png")
export(bool) var flip = true

func _ready():
	if obstacle:
		$Sprite.set_texture(obstacle)
	if flip == true:
		$Sprite.set_flip_h(true)
