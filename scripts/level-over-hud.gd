extends CanvasLayer

export (String) var final_score = ""
export (String) var final_time = ""

signal done

func _ready():
	$SpamDeliveredLabed/spamDeliveredValueLabel.text = final_score
	$TimeLeftLabel/timeLeftValueLabel.text = final_time
	

func _on_TextureButton_pressed():
	emit_signal("done")
