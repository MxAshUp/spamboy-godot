extends KinematicBody2D

export (int) var acceleration = 100
export (int) var max_speed = 200
export (int) var friction = 100

export (int) var vertical_snap = 16
export (int) var vertical_snap_speed = 10

var velocity = Vector2()
var origin_y
var snapping_to_y

func _ready():
	origin_y = position.y
	snapping_to_y = origin_y

func _physics_process(delta):
	var change_x_velocity = 0
	var change_y_velocity = 0

	if Input.is_action_pressed("ui_left"):
		change_x_velocity -= acceleration

	if Input.is_action_pressed("ui_right"):
		change_x_velocity += acceleration

	if Input.is_action_pressed("ui_up"):
		change_y_velocity -= 1

	if Input.is_action_pressed("ui_down"):
		change_y_velocity += 1

  # update horizontal veloxity
	velocity.x += change_x_velocity

	# apply horizontal friction
	velocity.x -= min(abs(velocity.x), friction) * sign(velocity.x)

	# don't allow x velocity to exceed max speed 
	if abs(velocity.x) > max_speed:
		velocity.x = sign(velocity.x) * max_speed

	# decide which y position to snap to
	if abs(change_y_velocity) > 0:
		snapping_to_y = floor((position.y + change_y_velocity * vertical_snap / 4 - origin_y) / vertical_snap) * vertical_snap + origin_y
		if change_y_velocity > 0:
			snapping_to_y += vertical_snap
	
	abs(velocity.x) / max_speed

	# set vertical velocity based on which position to snap to
	if abs(snapping_to_y - position.y) > 0:
		velocity.y = (snapping_to_y - position.y) * vertical_snap_speed * min(max(0.02, abs(velocity.x) / max_speed), 0.5) * 2

	# move player
	position += velocity * delta
