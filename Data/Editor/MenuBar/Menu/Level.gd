extends "res://Data/Editor/MenuBar/Menu/MenuButton.gd"

const PREFS := preload("res://Data/Editor/LevelPrefs/LevelPrefs.tscn")

var prefsW

func _ready():
	popup.add_item("Preferences")
	popup.add_item("Clear Contents")
	
func _popupButtonPress(id := 0):
	._popupButtonPress(id)
	
	match id:
		0:
			_openPrefsWindow()
		1:
			Main.level.clearContents()
	
func _openPrefsWindow():
	if prefsW: return
	
	prefsW = PREFS.instance()
	prefsW.connect("tree_exited", self, "_onPrefsWindowClose")
	
	editor.guiLayer.add_child(prefsW)
	
func _onPrefsWindowClose():
	prefsW = null
