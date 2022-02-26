extends TextureButton

func _ready():
	Main.level.darkMode = !pressed
	
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
func _input(event):
	if event.is_action_pressed("set_dark"):
		pressed = !pressed
		Main.level.darkMode = !pressed
	
func _mouseIn():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _mouseOut():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
	
func _toggled(button_pressed):
	Main.level.darkMode = !button_pressed
