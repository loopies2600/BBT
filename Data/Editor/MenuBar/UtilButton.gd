extends TextureButton

func _ready():
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	_unused = connect("pressed", self, "_press")
	
func _mouseIn():
	Global.cursor.pointer = 1
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _mouseOut():
	Global.cursor.pointer = 0
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
	
func _press():
	for b in get_parent().get_children():
		if b.is_in_group("Refresh"):
			if b.pressed: b.pressed = false
	
	pressed = !pressed
