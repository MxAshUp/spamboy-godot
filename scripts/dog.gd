extends KinematicBody2D

#TODO chasing doggo

var chasing = false
var toBeKilled = false

func _ready():
	pass


func _physics_process(delta):
	if chasing:
		#chase code
		pass
	elif toBeKilled:
		if not inScene():
			queue_free()


func _on_startChase_timeout():
	#Autostarted timer
	chasing = true
	$AnimationPlayer.play("walk")


func _on_chaseDuration_timeout():
	chasing = false
	
	#Check if in scene
	if not inScene():
		queue_free()
	else:
		$AnimationPlayer.play("idle")
		toBeKilled = true

func inScene():
	#TODO check if visible
	return true