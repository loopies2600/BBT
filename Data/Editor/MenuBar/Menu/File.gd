extends "res://Data/Editor/MenuBar/Menu/MenuButton.gd"

func _ready():
	popup.add_item("Open")
	popup.add_item("Save")
	
	if OS.get_name() != "HTML5":
		popup.add_item("Exit")
	
func _popupButtonPress(id := 0):
	match id:
		0:
			Main.setNewLevel()
		2:
			get_tree().quit(0)
