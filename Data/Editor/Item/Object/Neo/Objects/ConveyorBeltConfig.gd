extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _ready():
	_addTab("Belt")
	_addRow("Motion")
	_addVariableBox(0, "speedBoost", "Speed")
	_addRow("")
	_addVariableBox(0, "direction", "Direction")
	
