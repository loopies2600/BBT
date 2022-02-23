extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var midX := $P/Ctl/T/Vbc/Hbc2/Vbc/Hbc/Vbc/MXPos
onready var midY := $P/Ctl/T/Vbc/Hbc2/Vbc/Hbc/Vbc2/MYPos

onready var eX := $P/Ctl/T/Vbc/Hbc3/Vbc/Hbc/Vbc/EXPos
onready var eY := $P/Ctl/T/Vbc/Hbc3/Vbc/Hbc/Vbc2/EYPos

func _ready():
	midX.text = str(round(target.middle.x / 16))
	midY.text = str(round(target.middle.y / 16))
	
	eX.text = str(round(target.end.global_position.x / 16))
	eY.text = str(round(target.end.global_position.y / 16))
	
	var _unused = midX.connect("text_entered", self, "_midXChange")
	_unused = midY.connect("text_entered", self, "_midYChange")
	
	_unused = eX.connect("text_entered", self, "_eXChange")
	_unused = eY.connect("text_entered", self, "_eYChange")
	
func _midXChange(new := "0"):
	target.middle.x = int(new) * 16
	
func _midYChange(new := "0"):
	target.middle.y = int(new) * 16
	
func _eXChange(new := "0"):
	target.end.global_position.x = int(new) * 16
	
func _eYChange(new := "0"):
	target.end.global_position.y = int(new) * 16
	
func _setupRotation():
	pass
	
func _setupScale():
	pass

func _xPosChange(new := "0"):
	target.start.global_position.x = int(new) * 16
	target.global_position.x = int(new) * 16
	
	targetTile = (target.global_position / 16).round()
	
func _yPosChange(new := "0"):
	target.start.global_position.y = int(new) * 16
	target.global_position.y = int(new) * 16
	
	targetTile = (target.global_position / 16).round()
