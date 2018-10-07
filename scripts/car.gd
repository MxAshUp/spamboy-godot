extends StaticBody2D



var carHasToBrake = false
var ignoreBreakAreaOnPlayer = false
var maxSpeed = 0
var velocity = Vector2()
var move_direction = 1

func _ready():
	$blueLight.enabled = false
	$redLight.enabled = false

func init(pMaxSpeed, forcePoliceCar = false):
	if forcePoliceCar == true:
		#Spawning car shall be a police car
		$Sprite.set_frame(0)
		#ignoreBreakAreaOnPlayer = true
		$policeAnim.play("blueLight")
	else:
		#Random car
		$Sprite.set_frame(randi() % 3 + 1)
	#Setting max speed
	maxSpeed = pMaxSpeed
	velocity = Vector2(maxSpeed, 0)
	
	$debug.set_text(str(maxSpeed))

func _physics_process(delta):
	#TODO dummy impl
	if not carHasToBrake:
		if abs(velocity.x) < maxSpeed:
			velocity.x += 50 * delta * move_direction
		if abs(velocity.x) > maxSpeed:
			velocity.x = maxSpeed * sign(velocity.x)
	else:
		velocity.x -= min(500 * delta, abs(velocity.x)) * move_direction
	
	$driveAnim.playback_speed = float(velocity.x/350.0)

	position += velocity * delta

func _on_breakingArea_body_entered(body):
	if body == self:
		return
		
	#Shall the car hit the player?
	if ignoreBreakAreaOnPlayer and body.get_name() == "player":
		return
	else:
		carHasToBrake = true

func _on_breakingArea_body_exited(body):
	if body == self:
		return
		
	if ignoreBreakAreaOnPlayer and body.get_name() == "player":
		return
	else:
		carHasToBrake = false
