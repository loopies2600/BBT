extends "res://Data/Editor/MenuBar/UtilButton.gd"

func _input(event):
	if event.is_action_pressed("set_config"):
		_refreshButtons()
		pressed = true
		_setMode()
	
func _pressed():
	_setMode()

func _setMode():
	get_tree().get_nodes_in_group("Editor")[0].desc.msg(tr("E_SIDEBAR_CONFIG"))
	get_tree().get_nodes_in_group("Cursor")[0].mode = 2
