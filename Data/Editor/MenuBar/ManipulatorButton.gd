extends TextureButton

export (String) var property
export (String) var action

func _ready():
	get_tree().get_nodes_in_group("Editor")[0].set(property, pressed)
	
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
func _input(event):
	if event.is_action_pressed(action):
		pressed = !pressed
		get_tree().get_nodes_in_group("Editor")[0].set(property, pressed)
	
func _mouseIn():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _mouseOut():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
	
func _toggled(button_pressed):
	get_tree().get_nodes_in_group("Editor")[0].set(property, button_pressed)
