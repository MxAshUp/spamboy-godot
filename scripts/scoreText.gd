extends Node2D

export (String) var text = "" setget setText


func setText(new_text):
	if $container/text:
		$container/text.text = new_text
	if $container/shadow:
		$container/shadow.text = new_text
	text = new_text