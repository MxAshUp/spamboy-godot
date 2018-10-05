extends Control

func _ready():
	videoSetup()

func videoSetup():
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size() * 4
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	OS.set_window_size(window_size)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
