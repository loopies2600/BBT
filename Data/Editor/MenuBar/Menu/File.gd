extends "res://Data/Editor/MenuBar/Menu/MenuButton.gd"

func _ready():
	popup.add_item(tr("E_FILE_OPEN"))
	popup.add_item(tr("E_FILE_SAVE"))
	
	if OS.get_name() != "HTML5":
		popup.add_item(tr("E_FILE_EXIT"))
	
func _popupButtonPress(id := 0):
	._popupButtonPress(id)
	
	match id:
		0:
			Main.setNewLevel()
		1:
			Main.saveLevel()
		2:
			get_tree().quit(0)
