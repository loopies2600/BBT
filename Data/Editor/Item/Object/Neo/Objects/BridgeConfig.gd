extends "res://Data/Editor/Item/Object/Neo/ObjectConfig.gd"

func _tabSetup():
	._tabSetup()
	
	_addRow("Segments")
	
	_addVariableBox(0, "segAmt", "Amount")
