extends Node2D

signal level_changed()
signal level_saved()

onready var cursor := $Cursor
onready var utilButtons := $GUILayer/Sidebar/UtilButtons
onready var cam : Camera2D = Main.cam
onready var guiLayer := $GUILayer
onready var desc := $GUILayer/Descriptor
onready var llButton := $GUILayer/PlaceOptions/PC/CenterContainer/Vbc/TextHbc/LayerVbc/LevelLayout

var showGrid := false
var showCells := false

func _ready():
	OS.set_window_title("Bennett Boy's Workshop")
	
	Main.editing = true
	
func _process(_delta):
	if Main.editing:
		Main.entityLookTowards = get_global_mouse_position()
	
func setNewLevel():
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	var newLvl = Tools.openFilePicker()
	
	if OS.get_name() == "HTML5":
		return
		
	if newLvl:
		Main.reload(newLvl)
		emit_signal("level_changed")
		
func saveLevel():
	if !levelIsValid(): return
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	if OS.get_name() == "HTML5":
		Main.level.saveLvl()
		
		yield(get_tree(), "idle_frame")
		
		Tools.webFileTool.downloadLevel()
		return
		
	var path : String = Tools.openFolderPicker()
	
	if path:
		Main.level.saveLvl(path)
		emit_signal("level_saved")
		
func _input(event):
	if event.is_action_pressed("switch_state"):
		_switchStates()
		
func _switchStates():
	Main.level.saveLvl()
	
	if !levelIsValid(): return
	
	Main.editing = !Main.editing
	
	Main.level.resetObjectState()
	
	if !Main.editing:
		cursor.configuratorCheck()
		
		Main.level.copyMap()
		
		if Main.level.get("mus"):
			Main.level.mus.play()
		
		cursor.targetTilemap = Main.level
		llButton.enable()
	else:
		Main.level.restoreMap()
		
		_resetPlayValues()
		
		if Main.level.get("mus"):
			Main.level.mus.stop()
		
		Main.cam.global_position = Vector2.ZERO
		
	cursor.canPlace = Main.editing
	Main.emit_signal("game_mode_changed", Main.editing)
	
func _resetPlayValues():
	Main.attempt = 1
	Main.hud.aLabel.text = "ATTEMPT %s" % Main.attempt
	
func restart():
	Main.attempt += 1
	Main.hud.aLabel.text = "ATTEMPT %s" % Main.attempt
	
	Main.level.resetObjectState()
	Main.level.restoreMap()
	
func levelIsValid() -> bool:
	var hasPlayer := false
	var hasTiles : bool = Main.level.get_used_cells().size() != 0
	
	if Main.level.get_node("Player"):
		hasPlayer = true
	
	if !hasTiles:
		_message("Level is empty!")
		return false
	
	if !hasPlayer: 
		_message("No player found!") 
		return false
		
	return true
	
func _message(text := "ERROR", title := "Error!"):
	if guiLayer.get_node("Message"): return
	
	var newMsg = load("res://Data/Editor/Message.tscn").instance()
	guiLayer.add_child(newMsg)
	
	newMsg.desc.text = text
	newMsg.title.text = title
