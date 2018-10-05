#extends KinematicBody2D
extends Node2D


func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x -= 200*delta
	elif Input.is_action_pressed("ui_right"):
		position.x += 200*delta
