extends "res://Data/Editor/MenuBar/Menu/MenuButton.gd"

const BUGS := preload("res://Data/Editor/KnownBugs.tscn")

var bugsW

func _ready():
	popup.add_item("Known Bugs")
	
func _popupButtonPress(id := 0):
	._popupButtonPress(id)
	
	_openBugsWindow()
	
func _openBugsWindow():
	if bugsW: return
	
	bugsW = BUGS.instance()
	bugsW.connect("tree_exited", self, "_onBugsWindowClose")
	
	editor.guiLayer.add_child(bugsW)
	
func _onBugsWindowClose():
	bugsW = null
