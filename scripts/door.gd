extends Node2D

var open = false

export(String, "NOTHING", "DOG", "ANGRYMEN") var behindDoor = "NOTHING"

var grumbleAtObject = null
var grumbling = false

func _ready():
	$doorSprite.set_frame(0)
	$angrymen.hide()

func _process(delta):
	if grumbleAtObject and grumbling:
		grumbleAtObject.grumbled_at(delta)

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
				$grumble.play()
				grumbling = true
			_:
				#Door wont open - return
				return
		open = true
		$doorSprite.set_frame(1)


func _on_Area2D_body_entered(body):
	if body.get_name() == "player":
		grumbleAtObject = body


func _on_Area2D_body_exited(body):
	if body.get_name() == "player":
		grumbleAtObject = null
