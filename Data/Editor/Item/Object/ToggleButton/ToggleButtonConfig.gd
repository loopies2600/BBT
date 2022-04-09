extends "res://Data/Editor/Item/Object/ObjectConfig.gd"

onready var modeMenu := $P/Ctl/Transform/Vbc/Mode
onready var popup : PopupMenu

func _ready():
	popup = modeMenu.get_popup()
	popup.set_script(load("res://Data/Editor/AntiCursor.gd"))
	
	popup.add_item("Red")
	popup.add_item("Blue")
	
	var _unused = popup.connect("id_pressed", self, "_popupButtonPress")
	
func _process(_delta):
	modeMenu.text = "Mode: %s" % ("Red" if target.mode == 0 else "Blue")
	
func _popupButtonPress(id := 0):
	target.mode = id

