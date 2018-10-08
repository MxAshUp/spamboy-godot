extends Area2D

export (bool) var flip_h = false setget flip_set

func flip_set(is_flip):
	if $Sprite:
		$Sprite.flip_h = is_flip