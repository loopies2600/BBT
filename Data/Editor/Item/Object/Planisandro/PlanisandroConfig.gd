extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var rd := $P/Ctl/Reaction/Vbc/Hbc/Vbc2/RD
onready var wd := $P/Ctl/Reaction/Vbc/Hbc/Vbc/WD
onready var auto := $P/Ctl/Reaction/Vbc/Hbc2/Vbc/Hbc/A

func _ready():
	rd.text = str(target.disableTime)
	wd.text = str(target.waitTime)
	auto.pressed = target.auto
	
	var _unused = rd.connect("text_entered", self, "_rdChange")
	_unused = wd.connect("text_entered", self, "_wdChange")
	_unused = auto.connect("pressed", self, "_onAutoPress")
	
func _rdChange(new := ""):
	target.disableTime = float(new)
	
func _wdChange(new := ""):
	target.waitTime = float(new)
	
func _onAutoPress():
	target.auto = auto.pressed
	target.resetState()
