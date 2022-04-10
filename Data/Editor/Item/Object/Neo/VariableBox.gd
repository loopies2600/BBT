extends VBoxContainer

enum Types {INT, FLOAT}

onready var editor : Node2D = get_tree().get_nodes_in_group("Editor")[0]

onready var varName := $VariableName
onready var value := $Value

var target : Node2D
var tgVar := ""
var type := 0
var mult := 1

func _ready():
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
	value.text = str(target.get_indexed(tgVar))
	
	match type:
		0, 1:
			value.text = str(target.get_indexed(tgVar) / mult)
	
	_unused = value.connect("text_entered", self, "_varChange")
	
func _varChange(new := ""):
	var typeCast = new
	
	match type:
		Types.INT:
			typeCast = int(new) * mult
		Types.FLOAT:
			typeCast = float(new) * mult
	
	target.set_indexed(tgVar, typeCast)
	
	owner.updateConfigurator()
	
func _mouseIn():
	editor.cursor.canPlace = false
	
func _mouseOut():
	editor.cursor.canPlace = true
	
