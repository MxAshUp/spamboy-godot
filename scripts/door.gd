extends Node2D

var open = false
signal open_door

export(String, "NOTHING", "GRANDMA", "ANGRYMEN") var behindDoor = "NOTHING"

var grumbleAtObject = null
var grumbling = false
export (float) var chase_speed = 10
var chasing = false
var move_direction = Vector2()
			
func _ready():
	$doorSprite.set_frame(0)
	$Area2D/angrymen.hide()
	$Area2D/grandma.hide()
	connect("open_door", self, "openDoor")

func _process(delta):
	if grumbling:
		if grumbleAtObject:
			grumbleAtObject.grumbled_at(delta)
			if grumbleAtObject.position.x < ($Area2D.position + position).x:
				$Area2D/angrymen.flip_h = true
				$Area2D/grandma.flip_h = true
			else:
				$Area2D/angrymen.flip_h = false
				$Area2D/grandma.flip_h = false
			if chasing:
				var move_offset = Vector2(0, -24)
				move_direction = Vector2()
				move_direction = grumbleAtObject.position - ($Area2D.position + position + move_offset)

		if abs(move_direction.y) > 5:
			move_direction.x = 0
		
		if abs(move_direction.y) < 5 or abs($Area2D.position.y) > 24:
			move_direction.y = 0
			
		if abs(move_direction.x) < 5 or abs($Area2D.position.x) > 8:
			move_direction.x = 0
			
		move_direction = move_direction.normalized() * chase_speed
		$Area2D.position += move_direction * delta

#TODO maybe animation
func openDoor():
	if not open:
		match behindDoor:
			"GRANDMA":
				$Area2D/grandma.show()
				$AnimationPlayer.play("grandma")
				$grumble2.play()
				grumbling = true
			"ANGRYMEN":
				$Area2D/angrymen.show()
				$AnimationPlayer.play("angrymen")
				$grumble.play()
				grumbling = true
				chasing = true
			_:
				#Door wont open - return
				return
		open = true
		$doorOpenClose.play()
		$doorSprite.set_frame(1)

func closeDoor():
	if open:
		$doorOpenClose.play()
		$Area2D/angrymen.hide()
		$Area2D/grandma.hide()
		$Area2D.position = Vector2(0,0)
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
