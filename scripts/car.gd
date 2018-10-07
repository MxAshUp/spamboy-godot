extends KinematicBody2D



var carHasToBrake = false
var ignoreBreakAreaOnPlayer = false
var maxSpeed = 0

func _ready():
	$blueLight.enabled = false
	$redLight.enabled = false

func init(pMaxSpeed, forcePoliceCar = false):
	if forcePoliceCar == true:
		#Spawning car shall be a police car
		$Sprite.set_frame(0)
		ignoreBreakAreaOnPlayer = true
		$policeAnim.play("blueLight")
	else:
		#Random car
		$Sprite.set_frame(randi() % 3 + 1)
	#Setting max speed
	maxSpeed = pMaxSpeed
	
	$debug.set_text(str(maxSpeed))

func _physics_process(delta):
	#TODO dummy impl
	if not carHasToBrake:
		move_and_slide(Vector2(1,0).normalized()*maxSpeed)
		$driveAnim.playback_speed = float(maxSpeed/350.0)
	else:
		$driveAnim.playback_speed = 0.1
	

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
