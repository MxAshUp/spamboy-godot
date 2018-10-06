extends Node2D

var scoreScene = preload("res://scenes/scoreText.tscn")

func _ready():
	$debug.hide()

func feed():
	$AnimationPlayer.play("feeded")
	var score = scoreScene.instance()
	score.position = $scoreSpawn.position
	self.add_child(score)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		feed()

func _on_Area2D_body_entered(body):
	print("body entered: "+str(body))
