extends "res://Data/Editor/MenuBar/UtilButton.gd"

func _input(event):
	if event.is_action_pressed("set_place"):
		_refreshButtons()
		pressed = true
		get_tree().get_nodes_in_group("Cursor")[0].mode = 0
	
func _pressed():
	get_tree().get_nodes_in_group("Cursor")[0].mode = 0
