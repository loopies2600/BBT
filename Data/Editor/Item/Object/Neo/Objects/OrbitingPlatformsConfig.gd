extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _tabSetup():
	._tabSetup()
	
	_addTab("Platforms")
	
	_addRow("")
	_addVariableBox(0, "distance", "Distance")
	_addVariableBox(0, "amount", "Amount")
	
	_addRow("")
	_addVariableBox(1, "delayTime", "Delay")
	_addVariableBox(1, "speed", "Speed")
	
func updateConfigurator():
	.updateConfigurator()
	
	target._spawnPlatforms()
