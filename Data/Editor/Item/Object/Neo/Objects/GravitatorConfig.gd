extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _tabSetup():
	._tabSetup()
	
	_addRow("Gravity")
	_addSwitch("reverse", "Reverse")
