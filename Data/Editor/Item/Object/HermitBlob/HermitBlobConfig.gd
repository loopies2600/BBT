extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var jh := $P/Ctl/Motion/Vbc/Hbc/Vbc2/JH
onready var jd := $P/Ctl/Motion/Vbc/Hbc/Vbc/JD
onready var jt := $P/Ctl/Motion/Vbc/Hbc2/Vbc/Hbc/Vbc/JT
onready var ft := $P/Ctl/Motion/Vbc/Hbc2/Vbc/Hbc/Vbc2/FT

func _ready():
	jh.text = str(target.jumpHeight)
	jd.text = str(target.jumpDelay)
	jt.text = str(target.jumpDuration)
	ft.text = str(target.fallDuration)
	
	var _unused = jh.connect("text_entered", self, "_jhChange")
	_unused = jd.connect("text_entered", self, "_jdChange")
	_unused = jt.connect("text_entered", self, "_jtChange")
	_unused = ft.connect("text_entered", self, "_ftChange")
	
func _jhChange(new := "0"):
	target.jumpHeight = int(new)
	
	target.recalcJumpValues()
	
func _jdChange(new := "0"):
	target.jumpDelay = float(new)
	
	target.recalcJumpValues()
	
func _jtChange(new := "0"):
	target.jumpDuration = float(new)
	
	target.recalcJumpValues()
	
func _ftChange(new := "0"):
	target.fallDuration = float(new)
	
	target.recalcJumpValues()
