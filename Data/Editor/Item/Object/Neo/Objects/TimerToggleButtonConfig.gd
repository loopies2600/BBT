extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _tabSetup():
	._tabSetup()
	
	_addRow("Timer")
	
	_addVariableBox(1, "duration", "Duration")
