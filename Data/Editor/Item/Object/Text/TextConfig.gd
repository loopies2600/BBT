extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var text := $Panel/Controls/TextVal

func _ready():
	text.text = target.label.text
	
	var _unused = text.connect("text_changed", self, "_textChange")
	
func _textChange(new):
	target.label.text = new
