extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _tabSetup():
	._tabSetup()
	
	_addRow("Behavior")
	
	_addSwitch("main", "Main Button")
