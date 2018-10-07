extends Node2D

func _ready():
	# Connect all mailbox "feed" signals
	for i in get_tree().get_nodes_in_group("mailbox"):
		i.connect("feed", self, "handle_feed")

# todo - score and such
func handle_feed():
	print("score!")
