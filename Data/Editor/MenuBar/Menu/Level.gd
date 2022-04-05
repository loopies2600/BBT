extends "res://Data/Editor/MenuBar/Menu/MenuButton.gd"

func _ready():
	popup.add_item("Clear Level")
	popup.add_check_item("Dark Mode")
	popup.add_check_item("Tile Background")
	
	popup.set_item_checked(2, true)
	
func _popupButtonPress(id := 0):
	._popupButtonPress(id)
	
	match id:
		0:
			Main.level.clearContents()
		1:
			var booly := !popup.is_item_checked(1)
			
			popup.set_item_checked(1, booly)
			Main.level.darkMode = booly
		2:
			var booly := !popup.is_item_checked(2)
			
			popup.set_item_checked(2, booly)
			
			Main.background.mode = 0 if booly else 1
