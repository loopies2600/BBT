extends CheckButton

onready var editor : Node2D = get_tree().get_nodes_in_group("Editor")[0]

var tgVar := ""
var target

func _ready():
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
func _mouseIn():
	editor.cursor.canPlace = false
	
func _mouseOut():
	editor.cursor.canPlace = true
	
func _pressed():
	target.set_indexed(tgVar, !target.get_indexed(tgVar))
	
	owner.updateConfigurator()
