extends "res://Data/Editor/MenuBar/UtilButton.gd"

func _process(_delta):
	Main.hintPanel.mode = int(pressed)

func _input(event):
	if event.is_action_pressed("set_config"):
		_refreshButtons()
		pressed = true
