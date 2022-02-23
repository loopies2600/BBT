extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var eRadius := $P/Ctl/T2/Hbc/Vbc/ER
onready var eDelay := $P/Ctl/T2/Hbc/Vbc2/ED

func _ready():
	eRadius.text = str(target.area.shape.radius)
	eDelay.text = str(target.explosionDelay)
	
	var _unused = eRadius.connect("text_entered", self, "_radiusChange")
	_unused = eDelay.connect("text_entered", self, "_delayChange")
	
func _radiusChange(new := "0"):
	target.area.shape.radius = float(new)
	
func _delayChange(new := "0"):
	target.explosionDelay = float(new)
