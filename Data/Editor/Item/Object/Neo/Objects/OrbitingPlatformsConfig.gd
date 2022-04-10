extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _ready():
	_addTab("Platforms")
	
	_addRow("")
	_addVariableBox(0, "distance", "Distance")
	_addVariableBox(0, "amount", "Amount")
	
	_addRow("")
	_addVariableBox(1, "speed", "Speed")
	
func updateConfigurator():
	targetTile = (target.global_position / 16).round()
	
	target._spawnPlatforms()
