extends KinematicBody2D

export (int) var acceleration = 300
export (int) var max_speed = 250
export (int) var friction = 300
export (int) var crash_speed = 200

export (int) var walkling_acceleration = 400
export (int) var walking_max_speed = 75
export (int) var walking_friction = 600

export (bool) var is_biking = false

signal stuff_mail
signal delta_time
signal delta_score
var max_speed_factor = 1

var velocity = Vector2()
var ridable_bike = null
var last_move_dir = 1
var facing_up = false
var spamming = false

export (bool) var crashing = false

onready var masterNode = get_parent().get_parent().get_parent()

var textScene = preload("res://scenes/scoreText.tscn")

func _ready():
	$charSprite.set_frame(0)
	set_process(true)

# some conditions don't allow the player to move. Add those here.
func can_move_player():
	return !crashing and !spamming

func process_animation_state():
	var animation_to_play = $player_state_animation.current_animation
	$player_state_animation.playback_speed = 1

	if is_biking:
		
		if velocity.x:
			animation_to_play = "cycle_lr"
		else:
			animation_to_play = "idle_bike_lr"
		
		if crashing:
			animation_to_play = "crashing"
			
		# Handle left/right sprite mirror
		if sign(velocity.x) != 0:
			last_move_dir = sign(velocity.x)
		
	else:
		
		if max_speed_factor < 1:
			$player_state_animation.playback_speed = 0.6
		
		var left_right_move = false
		
		if animation_to_play == "walk_lr":
			animation_to_play = "idle_lr"
		elif animation_to_play == "walk_up":
			animation_to_play = "idle_up"
		elif animation_to_play == "walk_down":
			animation_to_play = "idle_lr"
		

		# Handle left/right sprite mirror
		if Input.is_action_pressed("ui_left"):
			last_move_dir = -1.0
			left_right_move = true
	
		if Input.is_action_pressed("ui_right"):
			last_move_dir = 1.0
			left_right_move = true
		
		if left_right_move:
			animation_to_play = "walk_lr"
		else:		
			if Input.is_action_pressed("ui_down"):
				animation_to_play = "walk_down"
			
			if Input.is_action_pressed("ui_up"):
				animation_to_play = "walk_up"

		if spamming:
			animation_to_play = "spamming_up"

	if animation_to_play != $player_state_animation.current_animation:
		$player_state_animation.play(animation_to_play)
		
	if animation_to_play.ends_with('_lr'):
		if last_move_dir < 0:
			$charSprite.flip_h = true
		elif last_move_dir > 0:
			$charSprite.flip_h = false
	
	if $player_state_animation.current_animation.ends_with("_up"):
		facing_up = true
	elif $player_state_animation.current_animation != "":
		facing_up = false

func is_trying_to_move():
	return Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")

func process_sounds():
	
	
	if !is_biking and is_trying_to_move() and velocity.length() > 20 and max_speed_factor == 1:
		if !$Sounds/walking.playing:
			$Sounds/walking.play()
	elif velocity.length() < 20:
		if $Sounds/walking.playing:
			$Sounds/walking.stop()
			
	if is_biking and abs(velocity.x) > 0:# and is_trying_to_move():
		if !$Sounds/biking.playing:
			$Sounds/biking.play()
		$Sounds/biking.volume_db = -60 + min(1.0, abs(velocity.x) / max_speed) * 30
		print($Sounds/biking.volume_db)
		
	else:
		if $Sounds/biking.playing:
			$Sounds/biking.stop()
	
func _process(delta):
	if is_biking:
		$collision_bike.disabled = false
		$collision_char.disabled = true
	else:
		$collision_bike.disabled = true
		$collision_char.disabled = false
	
	if !is_biking and facing_up and Input.is_action_just_pressed("spam") and !spamming:
		spamming = true
		$spamThrottle.start()
		emit_signal("stuff_mail", self)

	if Input.is_action_just_pressed("ui_cancel"):
		masterNode.switchGameState(global.MAIN)

	process_animation_state()
	process_sounds()
		
func _physics_process(delta):
	if !crashing and is_biking:
		process_bike_physics(delta)
	elif !is_biking:
		process_walk_physics(delta)
		
	if Input.is_action_just_pressed("mount_bike") and can_move_player():
		
		# getting off the bikle
		if is_biking:
			dismount_bike()
		
		# Getting on the bike
		elif ridable_bike:
			mount_bike()		
			
func process_bike_physics(delta):
	var change_x_velocity = 0
	var change_velocity_angle = 0

	if Input.is_action_pressed("ui_left") and can_move_player():
		change_x_velocity -= 1

	if Input.is_action_pressed("ui_right") and can_move_player():
		change_x_velocity += 1

	if Input.is_action_pressed("ui_up") and can_move_player():
			change_velocity_angle -= 1

	if Input.is_action_pressed("ui_down") and can_move_player():
			change_velocity_angle += 1

	change_x_velocity = change_x_velocity * acceleration

	# apply horizontal friction
	if change_x_velocity == 0:
		velocity.x -= min(abs(velocity.x), friction * delta) * sign(velocity.x)
			
	# don't allow x velocity to exceed max speed 
	if abs(velocity.x) > max_speed:
		velocity.x = sign(velocity.x) * max_speed

	velocity.x += change_x_velocity * delta

	# set angle flat
	velocity = Vector2(velocity.length() * sign(velocity.x), 0)
	
	# adjust direction of bike
	if abs(change_velocity_angle) > 0:
		# turn by 22 degrees
		var turn_angle = change_velocity_angle * (PI / 16)
		# turn a little harder if "braking"
		if sign(change_x_velocity) == -sign(velocity.x):
			turn_angle = turn_angle * 1.5
		# adjust velocity direction
		velocity = velocity.rotated(turn_angle * sign(velocity.x))
	
	# move player
	var new_velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# Detect if our horizontal speed changed by a lot - then we crash! 
	if abs((new_velocity - velocity).x) > crash_speed:
		crashing = true
		$Sounds/crash.play()
		velocity = Vector2()
		
	velocity = new_velocity

func process_walk_physics(delta):

	var change_x_velocity = 0
	var change_y_velocity = 0

	if Input.is_action_pressed("ui_left") and can_move_player():
		change_x_velocity -= 1

	if Input.is_action_pressed("ui_right") and can_move_player():
		change_x_velocity += 1

	if Input.is_action_pressed("ui_up") and can_move_player():
		change_y_velocity -= 1

	if Input.is_action_pressed("ui_down") and can_move_player():
		change_y_velocity += 1

	change_x_velocity = change_x_velocity * walkling_acceleration
	change_y_velocity = change_y_velocity * walkling_acceleration

	# apply horizontal friction
	if change_x_velocity == 0:
		velocity.x -= min(abs(velocity.x), walking_friction * delta) * sign(velocity.x)
		
	# don't allow x velocity to exceed max walking speed 
	if abs(velocity.x) > walking_max_speed*max_speed_factor:
		velocity.x = sign(velocity.x) * walking_max_speed*max_speed_factor
	
	# apply vertical walking friction
	if change_y_velocity == 0:
		velocity.y -= min(abs(velocity.y), walking_friction * delta) * sign(velocity.y)

	# don't allow y velocity to exceed max speed 
	if abs(velocity.y) > walking_max_speed*max_speed_factor:
		velocity.y = sign(velocity.y) * walking_max_speed*max_speed_factor

	velocity.y += change_y_velocity * delta
	velocity.x += change_x_velocity * delta

	# move player
	var new_velocity = move_and_slide(velocity, Vector2(0, -1))
	
	velocity = new_velocity

func mount_bike():
	is_biking = true
	position = ridable_bike.position
	velocity = Vector2()
	ridable_bike.hide()
	
func dismount_bike():
	is_biking = false
	if ridable_bike:
		ridable_bike.flip_h = $charSprite.flip_h
		ridable_bike.position = position
		ridable_bike.show()
		move_and_collide(Vector2(0, -4))
	$player_state_animation.play("idle_lr")

func spawn_text(text, animation = "spawn_b", limit = 0):
	
	if limit > 0 and $spawnedText.get_child_count() >= limit:
		return
		
	var score = textScene.instance()
	score.text = text
	score.position = $spawnTextPos.position
	score.animation = animation
	score.text_color = Color(1,1,0,1)
	$spawnedText.add_child(score)
	
func grumbled_at(delta):
	# subtract time from available time
	max_speed_factor = 0.2
	$Timer.start()
	emit_signal("delta_time", - delta)
	spawn_text("Sorry!", "spawn_a", 1)

func _on_Area2D_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.get_name() == "bike":
		ridable_bike = area

func _on_Area2D_area_shape_exited(area_id, area, area_shape, self_shape):
	if area.get_name() == "bike" and !is_biking:
		ridable_bike = null

func _on_player_state_animation_animation_finished(anim_name):
	if anim_name == "crashing":
		crashing = false
		dismount_bike()
		


func _on_Timer_timeout_reset_max_speed():
	$Timer.stop()
	max_speed_factor = 1


func _on_spamThrottle_timeout():
	$spamThrottle.stop()
	spamming = false
