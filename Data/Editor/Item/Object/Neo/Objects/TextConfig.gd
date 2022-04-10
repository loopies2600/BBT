extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _ready():
	_addRow("Label")
	_addVariableBox(2, "label:text", "Text             ")
