extends "res://Data/Editor/MenuBar/Menu/MenuButton.gd"

func _ready():
	popup.add_item("Undo    CTRL + Z")
	popup.add_item("Redo    CTRL + R")
	popup.add_item("Clear Level")
	popup.add_check_item("Dark Mode")
	popup.add_check_item("Tile Background")
	
	_lvlChange()
	
func _lvlChange():
	popup.set_item_checked(3, Main.level.darkMode)
	popup.set_item_checked(4, true if Main.level.bg.mode == 0 else false)
	
func _process(_delta):
	popup.set_item_disabled(0, editor.cursor.tilePlacingHistory.empty())
	popup.set_item_disabled(1, editor.cursor.tileRemovalHistory.empty())
	
func _popupButtonPress(id := 0):
	._popupButtonPress(id)
	
	match id:
		0:
			editor.cursor._delTile()
		1:
			editor.cursor._plcTile()
		2:
			Main.level.clearContents()
		3:
			var booly := !popup.is_item_checked(1)
			
			popup.set_item_checked(1, booly)
			Main.level.darkMode = booly
			Main.olr.visible = booly
		4:
			var booly := !popup.is_item_checked(4)
			
			popup.set_item_checked(4, booly)
			
			Main.level.bg.mode = 0 if booly else 1
