extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _tabSetup():
	._tabSetup()
	
	_addRow("Explosion")
	
	_addVariableBox(1, "radius", "Radius")
	_addVariableBox(1, "explosionDelay", "Delay")
