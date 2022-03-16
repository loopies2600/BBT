extends "res://Data/Editor/MenuBar/Menu/MenuButton.gd"

func _ready():
	popup.add_item("Open")
	popup.add_item("Save")
	
	if OS.get_name() != "HTML5":
		popup.add_item("Exit")
	
func _popupButtonPress(id := 0):
	._popupButtonPress(id)
	
	match id:
		0:
			editor.setNewLevel()
		1:
			editor.saveLevel()
		2:
			get_tree().quit(0)
