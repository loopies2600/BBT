extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _ready():
	_addTab("Behavior")
	
	_addRow("Reaction")
	_addVariableBox(1, "disableTime", "Delay")
	_addVariableBox(1, "waitTime", "Wait")
	
	_addRow("")
	_addSwitch("auto", "Automatic", false)
	
func updateConfigurator():
	.updateConfigurator()
	
	target.resetState()
