extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var dirMenu := $P/Ctl/Transform/Vbc/Dir
onready var popup : PopupMenu
onready var spd := $P/Ctl/Transform/Vbc/Hbc2/Vbc/Hbc/Vbc3/Spd

func _ready():
	popup = dirMenu.get_popup()
	popup.set_script(load("res://Data/Editor/AntiCursor.gd"))
	
	popup.add_item("Right")
	popup.add_item("Left")
	
	var _unused = popup.connect("id_pressed", self, "_popupButtonPress")
	
	spd.text = str(target.speedBoost)
	
	_unused = spd.connect("text_entered", self, "_spdChange")
	
func _spdChange(new := "0"):
	target.speedBoost = int(new)
	
func _process(_delta):
	dirMenu.text = "Direction: %s" % ("Right" if target.dir == 0 else "Left")
	
func _popupButtonPress(id := 0):
	target.dir = id

