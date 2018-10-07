extends Node2D

signal feed

var scoreScene = preload("res://scenes/scoreText.tscn")

func _ready():
	$debug.hide()

func feed(sender):
	$AnimationPlayer.play("feeded")
	var score = scoreScene.instance()
	score.position = $scoreSpawn.position
	self.add_child(score)
	emit_signal("feed")


func _on_Area2D_body_entered(body):
	body.connect("stuff_mail",self,"feed") 

func _on_Area2D_body_exited(body):
	body.disconnect("stuff_mail",self,"feed") 
