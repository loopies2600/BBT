extends "res://Data/Editor/MenuBar/UtilButton.gd"

func _input(event):
	if event.is_action_pressed("set_move"):
		_refreshButtons()
		pressed = true
		get_tree().get_nodes_in_group("Editor")[0].desc.msg("Move mode")
		get_tree().get_nodes_in_group("Cursor")[0].mode = 1
	
func _pressed():
	get_tree().get_nodes_in_group("Editor")[0].desc.msg("Move mode")
	get_tree().get_nodes_in_group("Cursor")[0].mode = 1
