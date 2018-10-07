extends KinematicBody2D

var textureArray = [preload("res://assets/dummyCar.png")]
var policeCarTexture = preload("res://assets/dummyCar.png")

var carHasToBrake = false
var ignoreBreakAreaOnPlayer = false
var maxSpeed = 0



func init(pMaxSpeed, forcePoliceCar = false):
	if forcePoliceCar == true:
		#Spawning car shall be a police car
		$Sprite.set_texture(policeCarTexture)
		ignoreBreakAreaOnPlayer = true
	else:
		#Random car
		$Sprite.set_texture(textureArray[randi() % textureArray.size()])
	#Setting max speed
	maxSpeed = pMaxSpeed
	
	$debug.set_text(str(maxSpeed))

func _physics_process(delta):
	#TODO dummy impl
	if not carHasToBrake:
		move_and_slide(Vector2(1,0).normalized()*maxSpeed)
	

func _on_breakingArea_body_entered(body):
	#Shall the car hit the player?
	if ignoreBreakAreaOnPlayer and body.get_name() == "player":
		return
	else:
		carHasToBrake = true

func _on_breakingArea_body_exited(body):
	if ignoreBreakAreaOnPlayer and body.get_name() == "player":
		return
	else:
		carHasToBrake = false
