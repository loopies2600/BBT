extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _ready():
	_addRow("Bullets")
	
	_addVariableBox(1, "fireTime", "Firerate")
	_addVariableBox(0, "spikesPerShot", "Amount")

func updateConfigurator():
	.updateConfigurator()
	
	target.timer.wait_time = target.fireTime
