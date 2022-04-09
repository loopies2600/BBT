extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var midX := $P/Ctl/Transform/Vbc/Hbc2/Vbc/Hbc/Vbc/MXPos
onready var midY := $P/Ctl/Transform/Vbc/Hbc2/Vbc/Hbc/Vbc2/MYPos

onready var eX := $P/Ctl/Transform/Vbc/Hbc3/Vbc/Hbc/Vbc/EXPos
onready var eY := $P/Ctl/Transform/Vbc/Hbc3/Vbc/Hbc/Vbc2/EYPos

onready var spd := $P/Ctl/Worm/Vbc/Hbc/Vbc/Spd
onready var jmpDl := $P/Ctl/Worm/Vbc/Hbc/Vbc2/JmpDl

onready var p := $P/Ctl/Worm/Vbc/Hbc2/Vbc/Hbc/Vbc/P

func _ready():
	midX.text = str(round(target.middle.x / 16))
	midY.text = str(round(target.middle.y / 16))
	
	eX.text = str(round(target.end.global_position.x / 16))
	eY.text = str(round(target.end.global_position.y / 16))
	
	spd.text = str(target.speed)
	jmpDl.text = str(target.jumpDelay)
	
	p.text = str(target.parts)
	
	var _unused = midX.connect("text_entered", self, "_midXChange")
	_unused = midY.connect("text_entered", self, "_midYChange")
	
	_unused = eX.connect("text_entered", self, "_eXChange")
	_unused = eY.connect("text_entered", self, "_eYChange")
	
	_unused = spd.connect("text_entered", self, "_spdChange")
	_unused = jmpDl.connect("text_entered", self, "_jumpDlChange")
	
	_unused = p.connect("text_entered", self, "_pChange")
	
func _midXChange(new := "0"):
	target.middle.x = int(new) * 16
	
func _midYChange(new := "0"):
	target.middle.y = int(new) * 16
	
func _eXChange(new := "0"):
	target.end.global_position.x = int(new) * 16
	
func _eYChange(new := "0"):
	target.end.global_position.y = int(new) * 16
	
func _spdChange(new := "0"):
	target.speed = float(new)
	
func _jumpDlChange(new := "0"):
	target.jumpDelay = float(new)
	
func _pChange(new := "0"):
	target.parts = int(new)
	
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
