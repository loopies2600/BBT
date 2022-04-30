extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _tabSetup():
	._tabSetup()
	
	_addRow("Motion")
	_addVariableBox(0, "speedBoost", "Speed")
