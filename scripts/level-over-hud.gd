extends CanvasLayer

export (String) var final_score = ""
export (String) var final_time = ""
export (bool) var failed = false

signal done
signal next
signal retry

func _ready():
	$SpamDeliveredLabed/spamDeliveredValueLabel.text = final_score
	$TimeLeftLabel/timeLeftValueLabel.text = final_time
	if failed:
		$nextButton2.hide()
		$retryButton3.show()
	else:
		$nextButton2.show()
		$retryButton3.hide()
		

func _on_TextureButton_pressed():
	emit_signal("done")


func _on_NextButton_pressed():
	emit_signal("next")


func _on_RetryButton_pressed():
	emit_signal("retry")
