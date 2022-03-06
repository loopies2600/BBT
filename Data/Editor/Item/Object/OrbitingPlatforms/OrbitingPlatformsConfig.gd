extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var d := $P/Ctl/Platforms/Vbc/Hbc/Vbc2/D
onready var spd := $P/Ctl/Platforms/Vbc/Hbc/Vbc/Spd
onready var amt := $P/Ctl/Platforms/Vbc/Hbc2/Vbc/Hbc/Vbc/Amt

func _ready():
	d.text = str(target.distance)
	spd.text = str(target.speed)
	amt.text = str(target.amount)
	
	var _unused = d.connect("text_entered", self, "_dChanged")
	_unused = spd.connect("text_entered", self, "_spdChanged")
	_unused = amt.connect("text_entered", self, "_amtChanged")
	
func _dChanged(new := "0"):
	target.distance = int(new)
	
	for p in target.platforms:
		p.distance = target.distance
	
func _spdChanged(new := "0"):
	target.speed = float(new)
	
	for p in target.platforms:
		p.speed = target.speed
	
func _amtChanged(new := "0"):
	target.amount = int(new)
	
	target._spawnPlatforms()
