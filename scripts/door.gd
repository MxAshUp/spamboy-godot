extends Node2D

var open = false
signal open_door

export(String, "NOTHING", "GRANDMA", "ANGRYMEN") var behindDoor = "NOTHING"

var grumbleAtObject = null
var grumbling = false

func _ready():
	$doorSprite.set_frame(0)
	$angrymen.hide()
	$grandma.hide()

func _process(delta):
	if grumbleAtObject and grumbling:
		grumbleAtObject.grumbled_at(delta)
		if grumbleAtObject.position.x < position.x:
			$angrymen.flip_h = true
			$grandma.flip_h = true
		else:
			$angrymen.flip_h = false
			$grandma.flip_h = false

#TODO maybe animation
func openDoor():
	if not open:
		match behindDoor:
			"GRANDMA":
				$grandma.show()
				$AnimationPlayer.play("grandma")
				$grumble2.play()
				grumbling = true
			"ANGRYMEN":
				$angrymen.show()
				$AnimationPlayer.play("angrymen")
				$grumble.play()
				grumbling = true
			_:
				#Door wont open - return
				return
		open = true
		$doorOpenClose.play()
		$doorSprite.set_frame(1)

func closeDoor():
	if open:
		$doorOpenClose.play()
		$angrymen.hide()
		$grandma.hide()
		open = false
		$doorSprite.set_frame(0)
		$grumble.stop()

func _on_Area2D_body_entered(body):
	if body.get_name() == "player":
		if grumbling:
			$doneGrumblingTimer.stop()
			
		grumbleAtObject = body

func _on_Area2D_body_exited(body):
	if body.get_name() == "player":
		grumbleAtObject = null
		$doneGrumblingTimer.start()

func _on_doneGrumblingTimer_timeout():
	if grumbling:
		grumbling = false
		closeDoor()
