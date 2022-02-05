extends TextureButton

export (String) var property

func _ready():
	get_tree().get_nodes_in_group("Editor")[0].set(property, pressed)
	
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
func _mouseIn():
	Global.cursor.pointer = 1
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _mouseOut():
	Global.cursor.pointer = 0
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
	
func _toggled(button_pressed):
	get_tree().get_nodes_in_group("Editor")[0].set(property, button_pressed)
