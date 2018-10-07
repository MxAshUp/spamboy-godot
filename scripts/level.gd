extends Node2D


func _ready():
	for i in get_tree().get_nodes_in_group("mailbox"):
		i.connect("feed", self, "handle_feed")
	
func handle_feed():
	$audioSamples.play("ui_good")
