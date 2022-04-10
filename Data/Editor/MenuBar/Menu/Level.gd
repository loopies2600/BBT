extends "res://Data/Editor/MenuBar/Menu/MenuButton.gd"

func _ready():
	popup.add_item("Clear Level")
	popup.add_check_item("Dark Mode")
	popup.add_check_item("Tile Background")
	
	_lvlChange()
	
func _lvlChange():
	popup.set_item_checked(1, Main.level.darkMode)
	popup.set_item_checked(2, true if Main.level.bg.mode == 0 else false)
	
func _popupButtonPress(id := 0):
	._popupButtonPress(id)
	
	match id:
		0:
			Main.level.clearContents()
		1:
			var booly := !popup.is_item_checked(1)
			
			popup.set_item_checked(1, booly)
			Main.level.darkMode = booly
			Main.olr.visible = booly
		2:
			var booly := !popup.is_item_checked(2)
			
			popup.set_item_checked(2, booly)
			
			Main.level.bg.mode = 0 if booly else 1
