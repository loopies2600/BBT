extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _tabSetup():
	_addTab("Main")
	
	_addRow("Start Position")
	_addVariableBox(0, "global_position:x", "X", "none", 16)
	_addVariableBox(0, "global_position:y", "Y", "none", 16)
	_addVariableBox(0, "z_index", "Depth")
	
	_addRow("Mid Position")
	_addVariableBox(0, "middle:x", "X", "none", 16)
	_addVariableBox(0, "middle:y", "Y", "none", 16)
	
	_addRow("End Position")
	_addVariableBox(0, "end:global_position:x", "X", "none", 16)
	_addVariableBox(0, "end:global_position:y", "Y", "none", 16)
	
	_addTab("Worm")
	
	_addRow("Motion")
	_addVariableBox(1, "speed", "Speed")
	_addVariableBox(1, "jumpDelay", "Jump delay")
	
	_addRow("Body")
	_addVariableBox(0, "parts", "Parts")
