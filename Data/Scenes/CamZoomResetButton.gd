extends TextureButton

onready var editor : Node2D = get_tree().get_nodes_in_group("Editor")[0]

func _ready():
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
func _mouseIn():
	editor.cursor.canPlace = false
	
func _mouseOut():
	editor.cursor.canPlace = true
	
func _pressed():
	editor.cam.baseZoom = Vector2.ONE
