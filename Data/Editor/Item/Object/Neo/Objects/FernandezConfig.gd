extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _ready():
	_addRow("Explosion")
	
	_addVariableBox(1, "area:shape:radius", "Radius")
	_addVariableBox(1, "explosionDelay", "Delay")
