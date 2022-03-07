extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var fr := $P/Ctl/B/Vbc/Hbc/Vbc/FR
onready var amt := $P/Ctl/B/Vbc/Hbc/Vbc2/Amt

func _ready():
	fr.text = str(target.fireTime)
	amt.text = str(target.spikesPerShot)
	
	var _unused = fr.connect("text_entered", self, "_frChanged")
	_unused = amt.connect("text_entered", self, "_amtChanged")
	
func _frChanged(new := "0"):
	target.fireTime = float(new)
	target.timer.wait_time = target.fireTime
	
func _amtChanged(new := "0"):
	target.spikesPerShot = int(new)
