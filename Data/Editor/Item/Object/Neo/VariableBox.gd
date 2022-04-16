extends VBoxContainer

enum Types {INT, FLOAT}

onready var editor : Node2D = get_tree().get_nodes_in_group("Editor")[0]

onready var varName := $VariableName
onready var value := $Value

onready var configMan = Main.currentScene.cursor.modes[0]

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
	
	if tgVar in ["modulate:r", "modulate:g", "modulate:b", "modulate"]:
		add_to_group("LabelRefresh")
	
	if tgVar == "modulate":
		value.text = target.modulate.to_html(false)
		
func refresh():
	if tgVar == "modulate":
		value.text = target.modulate.to_html(false)
	else:
		value.text = str(target.get_indexed(tgVar))
		
func _varChange(new := ""):
	var typeCast = new
	
	match type:
		Types.INT:
			typeCast = int(new) * mult
		Types.FLOAT:
			typeCast = float(new) * mult
	
	target.set_indexed(tgVar, typeCast)
	
	if tgVar in ["scale:x", "scale:y", "rotation_degrees", "modulate:r", "modulate:g", "modulate:b"]:
		configMan.basePlaceOptions[tgVar] = float(value.text)
		
	if tgVar == "modulate":
		var col : Color = value.text
		
		configMan.basePlaceOptions["modulate:r"] = col.r
		configMan.basePlaceOptions["modulate:g"] = col.g
		configMan.basePlaceOptions["modulate:b"] = col.b
		
	owner.updateConfigurator()
	
func _mouseIn():
	editor.cursor.canPlace = false
	
func _mouseOut():
	editor.cursor.canPlace = true
	
