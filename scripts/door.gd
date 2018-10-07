extends Node2D

var open = false

export(String, "NOTHING", "DOG", "ANGRYMEN") var behindDoor = "NOTHING"



func _ready():
	$doorSprite.set_frame(0)
	$angrymen.hide()

#TODO maybe animation
func openDoor():
	if not open:
		match behindDoor:
			"DOG":
				pass
				#spawn chasing doggo
			"ANGRYMEN":
				$angrymen.show()
				$AnimationPlayer.play("angrymen")
			_:
				#Door wont open - return
				return
		open = true
		$doorSprite.set_frame(1)
