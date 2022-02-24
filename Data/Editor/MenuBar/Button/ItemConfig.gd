extends "res://Data/Editor/MenuBar/UtilButton.gd"

func _input(event):
	if event.is_action_pressed("set_config"):
		_refreshButtons()
		pressed = true
		get_tree().get_nodes_in_group("Editor")[0].desc.msg("Config mode")
		get_tree().get_nodes_in_group("Cursor")[0].mode = 2
		
func _pressed():
	get_tree().get_nodes_in_group("Editor")[0].desc.msg("Config mode")
	get_tree().get_nodes_in_group("Cursor")[0].mode = 2
