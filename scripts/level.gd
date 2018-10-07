extends Node2D

const carMaxSpeed = 350 #todo optimize value
const carMinSpeed = 50  #todo optimize value
const carSpawnOffset = Vector2(100, 0) #todo half screensize + offset so the car wont be seen

onready var lanes = [Vector2(0, 24), Vector2(0, 42), Vector2(0, 61)]
onready var playerNode = $YSort/player
onready var carScene = preload("res://scenes/car.tscn")

var carsInLevel = []

func _ready():
	# Connect all mailbox "feed" signals
	for i in get_tree().get_nodes_in_group("mailbox"):
		i.connect("feed", self, "handle_feed")

func _process(delta):
	updateCarSpawnLocations()

# todo - score and such
func handle_feed():
	print("score!")

func setCameraActive():
	$"YSort/player/cam".make_current()


func _input(event): #TODO remove me :>
	if event.is_action_pressed("ui_accept"):
		spawnCar()
		#spawnCar(true) #spawn police
	if event is InputEventMouseMotion:
		$hud/debug2.set_text(str(event.position))


func spawnCar(isPoliceCar = false):
	var selectedLane = lanes[(randi() % lanes.size())]
	var maxSpeed = max(carMinSpeed, (randi() % carMaxSpeed))

	#Instance and init car
	var thisCar = carScene.instance()
	thisCar.init(maxSpeed, isPoliceCar)
	
	if maxSpeed > playerNode.max_speed:
		#Spawn car behind player
		thisCar.position = selectedLane - carSpawnOffset
	else:
		#Spawn car in front of player
		thisCar.position = selectedLane + carSpawnOffset
	
	#todo check if there is another car at this position
	print(thisCar.position)
	
	#Add car to level
	$YSort.add_child(thisCar)
	carsInLevel.append(thisCar)
	
	#todo max count of cars, remove older cars which are out of players scope

func updateCarSpawnLocations():
	#Update X comp depending on players position
	lanes[0].x = playerNode.position.x
	lanes[1].x = playerNode.position.x
	lanes[2].x = playerNode.position.x
	$hud/debug.set_text(str(lanes[1]))