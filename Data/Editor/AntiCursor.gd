extends Control

func _ready():
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
func _mouseIn():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _mouseOut():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = true