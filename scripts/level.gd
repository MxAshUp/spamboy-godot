extends Node2D

const carMaxSpeed = 350 #todo optimize value
const carMinSpeed = 200  #todo optimize value
const carSpawnOffset = Vector2(256, 0)

onready var lanes = [Vector2(0, 24), Vector2(0, 42), Vector2(0, 61)]
onready var playerNode = $YSort/player
onready var carScene = preload("res://scenes/car.tscn")
onready var gameOverHud = preload("res://scenes/level-over-hud.tscn")
onready var hudCanvas = preload("res://scenes/hud.tscn")

signal game_over
signal next_level
signal retry_level
signal paused

export (int) var objective_spam_count = 0
export (float) var objective_seconds = 0 setget set_time_left
export (int) var spawning_cars = 0

var spam_delivered_count = 0
var time_left = 0
var level_active = false
var final_score = 0
var carsInLevel = []
var hud

var allowCheat = false

func _ready():
	hud = hudCanvas.instance()
	add_child(hud)
	
	#Setup timer
	if spawning_cars:
		$carSpawnTimer.set_wait_time(objective_seconds/(spawning_cars + 1))
		print($carSpawnTimer.wait_time)
		$carSpawnTimer.start()
	
	# Connect all mailbox "feed" signals
	for i in get_tree().get_nodes_in_group("mailbox"):
		i.connect("feed", self, "handle_feed")
	level_active = true
	get_tree().paused = false

func set_time_left(n_objective_seconds):
	objective_seconds = n_objective_seconds
	time_left = objective_seconds

#TODO cheat function
func _input(event):
	if event.is_action_pressed("cheatsActivate"):
		allowCheat = true

	if allowCheat:
		if event.is_action_pressed("cheat"):
			spam_delivered_count = objective_spam_count
		if event.is_action_pressed("spawn"):
			spawnCar()


func _process(delta):
	updateCarSpawnLocations()
	process_score(delta)
	
	# infinite up/down boundaries
	$boundaries.position.x = $YSort/player.position.x
	
	if Input.is_action_just_pressed("ui_cancel") and $pauseThrottle.time_left == 0 and level_active:
		pause_level()

func _on_pauseThrottle_timeout():
	$pauseThrottle.stop()
	
func pause_level():
	$pauseThrottle.start()
	get_tree().paused = true
	emit_signal("paused", self)

func unpause_level():
	get_tree().paused = false
	show()
	setCameraActive()

func process_score(delta):
	if hud != null:
		hud.get_node("spam/spamDeliveredValueLabel").text = ("%02d" % spam_delivered_count) + "/" +  ("%02d" % objective_spam_count)
		var sec_left = floor(fmod(time_left, 60))
		var min_left = floor(time_left / 60)
		hud.get_node("time/timeLeftValueLabel").text = ("%02d" % min_left) + ":" + ("%02d" % sec_left)
	
	if level_active:
		time_left -= delta
		if time_left <= 0 or spam_delivered_count >= objective_spam_count:
			level_active = false
			# todo - calculate final score to send up to main
			final_score = time_left # just submit the remaining times as a score indicator
			if time_left < 0:
				time_left = 0
			var goh = gameOverHud.instance()
			if spam_delivered_count >= objective_spam_count:
				goh.failed = false
			else:
				goh.failed = true
			goh.final_score = ("%d" % spam_delivered_count) + " of " +  ("%d" % objective_spam_count)
			goh.final_time = ("%.3f" % time_left) + "s"
			if hud != null:
				hud.queue_free()
				hud = null
			add_child(goh)
			goh.connect("done", self, "quit_level")
			goh.connect("next", self, "next_level")
			goh.connect("retry", self, "retry_level")
			get_tree().paused = true

# todo - score and such
func handle_feed():
	spam_delivered_count += 1

func setCameraActive():
	$"YSort/player/cam".make_current()

func spawnCar(isPoliceCar = false):
	var selectedLane = lanes[(randi() % lanes.size())]
	var maxSpeed = max(carMinSpeed, (randi() % carMaxSpeed))

	#Instance and init car
	var thisCar = carScene.instance()
	thisCar.init(maxSpeed, isPoliceCar)
	
	#if maxSpeed > playerNode.velocity.x:
		#Spawn car behind player
	thisCar.position = selectedLane - carSpawnOffset
	#else:
		#Spawn car in front of player
	#	thisCar.position = selectedLane + carSpawnOffset
	
	#todo check if there is another car at this position
	#print(thisCar.position)
	
	#Add car to level
	$YSort.add_child(thisCar)
	carsInLevel.append(thisCar)
	#todo max count of cars, remove older cars which are out of players scope
	
	#Restart Timer
	$carSpawnTimer.start()

func updateCarSpawnLocations():
	if playerNode:
		lanes[0].x = playerNode.position.x
		lanes[1].x = playerNode.position.x
		lanes[2].x = playerNode.position.x

func _on_player_delta_time(delta):
	time_left += delta


func quit_level():
	emit_signal("game_over", self, final_score)
	
func next_level():
	print("1")
	emit_signal("next_level", self, final_score)
	
func retry_level():
	emit_signal("retry_level", self)
