extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _ready():
	_addTab("Motion")
	
	_addRow("")
	_addVariableBox(1, "maxSpd", "Max speed")
	_addRow("")
	_addVariableBox(1, "accel", "Acceleration")
	_addRow("")
	_addVariableBox(1, "damping", "Damping")
	_addRow("")
	_addVariableBox(1, "airDamping", "Air damping")
	
	_addTab("Dash & Slide")
	
	_addRow("Dash")
	_addVariableBox(1, "weight", "Weight")
	
	_addRow("Slide")
	_addVariableBox(1, "slideStrength", "Speed")
	_addVariableBox(1, "slideDuration", "Duration")
	
	_addTab("Jump")
	
	_addRow("")
	_addVariableBox(1, "jumpHeight", "Height")
	
	_addRow("Rise")
	_addVariableBox(1, "jumpDuration", "Duration")
	
	_addRow("Fall")
	_addVariableBox(1, "fallDuration", "Duration")
	
	_addTab("Misc")
	
	_addRow("")
	_addVariableBox(1, "resetDelay", "Level reset delay")
	
	_addRow("Rocket")
	_addVariableBox(1, "rocketSpeed", "Speed")
	_addRow("")
	_addVariableBox(1, "rocketAccel", "Acceleration")
	_addRow("")
	_addVariableBox(1, "rocketSteering", "Steering")
