extends ScrollContainer

onready var editor : Node2D = get_tree().get_nodes_in_group("Editor")[0]

func _ready():
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
	_unused = get_h_scrollbar().connect("mouse_entered", self, "_mouseIn")
	_unused = get_h_scrollbar().connect("mouse_exited", self, "_mouseOut")
	
func _mouseIn():
	editor.cursor.canPlace = false
	
func _mouseOut():
	editor.cursor.canPlace = true
	
