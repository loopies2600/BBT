extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var dirMenu := $P/Ctl/T/Vbc/Dir
onready var popup : PopupMenu

func _ready():
	popup = dirMenu.get_popup()
	popup.set_script(load("res://Data/Editor/AntiCursor.gd"))
	
	popup.add_item("Up")
	popup.add_item("Down")
	
	var _unused = popup.connect("id_pressed", self, "_popupButtonPress")
	
func _process(_delta):
	dirMenu.text = "Direction: %s" % ("Up" if target.mode == 0 else "Down")
	
func _popupButtonPress(id := 0):
	target.mode = id

