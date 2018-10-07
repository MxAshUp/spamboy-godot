extends Control


func _ready():
	#Setup our window-size and scaling
	videoSetup()
	#Initialize prng
	randomize()
	
	switchGameState(global.MAIN)



func videoSetup():
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size() * 4
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	OS.set_window_size(window_size)


func switchGameState(to):
	
	match to:
		global.MAIN:
			get_tree().set_pause(true)
			$menu.show()
			$menu.setCameraActive()
			$level.hide()
		global.GAME:
			get_tree().set_pause(false)
			$menu.hide()
			$level.show()
			$level.setCameraActive()
		_:
			print("error: undefined change")