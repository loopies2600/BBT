extends "res://Data/Editor/MenuBar/Menu/MenuButton.gd"

func _ready():
	popup.add_item("Clear")
	
func _popupButtonPress(id := 0):
	._popupButtonPress(id)
	
	match id:
		0:
			Main.level.clearContents()
