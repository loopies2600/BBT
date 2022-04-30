extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _tabSetup():
	._tabSetup()
	
	_addTab("Motion")
	
	_addRow("")
	_addVariableBox(1, "jumpDelay", "Jump delay")
	
	_addRow("")
	_addVariableBox(1, "jumpDuration", "Jump time")
	
	_addRow("")
	_addVariableBox(1, "fallDuration", "Fall time")
	
	_addRow("")
	_addVariableBox(0, "jumpHeight", "Jump height")
