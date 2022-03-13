extends MenuButton

onready var popup := get_popup()

func _ready():
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
	_unused = popup.connect("mouse_entered", self, "_mouseIn")
	_unused = popup.connect("mouse_exited", self, "_mouseOut")
	
	_unused = popup.connect("id_pressed", self, "_popupButtonPress")
	
func _mouseIn():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _mouseOut():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
	
func _popupButtonPress(id := 0):
	pass
