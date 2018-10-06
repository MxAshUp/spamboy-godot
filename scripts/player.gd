extends KinematicBody2D

export (int) var acceleration = 1000
export (int) var max_speed = 200
export (int) var friction = 1000

export (int) var vertical_snap = 16 

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

	velocity.x += change_x_velocity * delta
	velocity.x -= min(abs(velocity.x), friction * delta) * sign(velocity.x)

	if abs(velocity.x) > max_speed:
		velocity.x = sign(velocity.x) * max_speed

	# decide which y position to snap to
	if abs(change_y_velocity) > 0:
		snapping_to_y = floor((position.y + change_y_velocity - origin_y) / vertical_snap) * vertical_snap + origin_y
		if change_y_velocity > 0:
			snapping_to_y += vertical_snap

		print(snapping_to_y)

	if abs(snapping_to_y - position.y) > 0:
		velocity.y = (snapping_to_y - position.y) * 10

	position += velocity * delta
