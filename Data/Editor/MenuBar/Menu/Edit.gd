extends "res://Data/Editor/MenuBar/Menu/MenuButton.gd"

func _ready():
	
	popup.add_item("%s    CTRL + Z" % tr("E_EDIT_UNDO"))
	popup.add_item("%s    CTRL + R" % tr("E_EDIT_REDO"))
	popup.add_check_item(tr("E_EDIT_TILEBG"))
	
	_lvlChange()
	
func _lvlChange():
	popup.set_item_checked(2, true if Main.level.bg.mode == 0 else false)
	
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
			var booly := !popup.is_item_checked(2)
			
			popup.set_item_checked(2, booly)
			
			Main.level.bg.mode = 0 if booly else 1
