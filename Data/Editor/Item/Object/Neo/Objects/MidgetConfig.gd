extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _ready():
	_addTab("Behavior")
	
	_addRow("Seek radius")
	_addVariableBox(0, "tileSearchRadius", "Tile")
	_addVariableBox(0, "detectionRadius", "Player")
	
	_addRow("Delay")
	_addVariableBox(1, "seekDelay", "Seek")
	_addVariableBox(2, "tossDelay", "Toss")
	
	_addRow("Angry tile")
	_addVariableBox(0, "tileSpeed", "Speed")
