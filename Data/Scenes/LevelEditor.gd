extends Node2D

onready var cursor := $Cursor
onready var utilButtons := $GUILayer/Sidebar/UtilButtons
onready var cam := $Camera
onready var guiLayer := $GUILayer
onready var desc := $GUILayer/Descriptor

var showGrid := false
var showCells := false
var showCellBox := false

var player : Player

func _ready():
	OS.set_window_title("Bennett Boy's Workshop")
	
	Main.editing = true
	
func _process(_delta):
	if Main.editing:
		Main.entityLookTowards = get_global_mouse_position()
	
	# scroll BG
	Main.background.scroll_offset = get_canvas_transform().origin
	
func setNewLevel():
	var newLvl = Tools.openFilePicker()
	
	if OS.get_name() == "HTML5":
		return
		
	if newLvl:
		Main.reload(newLvl)
	
func saveLevel():
	if !levelIsValid(): return
	
	if OS.get_name() == "HTML5":
		Main.level.saveLvl()
		
		yield(get_tree(), "idle_frame")
		
		Tools.webFileTool.downloadLevel()
		return
		
	var path : String = Tools.openFolderPicker()
	
	if path:
		Main.level.saveLvl(path)
	
func _input(event):
	if event.is_action_pressed("switch_state"):
		_switchStates()
		
func _switchStates():
	Main.level.saveLvl()
	
	if !levelIsValid(): return
	
	Main.editing = !Main.editing
	cam.global_position = Vector2()
	
	Main.level.resetObjectState()
	
	if !Main.editing:
		if cursor.configurator:
			cursor.configurator.queue_free()
			cursor.configurator = null
		
		Main.level.copyMap()
	else:
		Main.level.restoreMap()
		
		_resetPlayValues()
		cam.current = true
		
	cursor.canPlace = Main.editing
	
func _resetPlayValues():
	if player:
		player.queue_free()
		player = null
		
	Main.attempt = 1
	Main.hud.aLabel.text = "ATTEMPT %s" % Main.attempt
	
func restart():
	Main.attempt += 1
	Main.hud.aLabel.text = "ATTEMPT %s" % Main.attempt
	
	Main.level.resetObjectState()
	Main.level.restoreMap()
	
func levelIsValid() -> bool:
	var hasSpawnPoint := false
	var hasTiles : bool = Main.level.get_used_cells().size() != 0
	
	for c in Main.level.get_children():
		if c.name == "Player":
			hasSpawnPoint = true
	
	if !hasTiles:
		_message("Level is empty!")
		return false
	
	if !hasSpawnPoint: 
		_message("No player found!") 
		return false
		
	return true
		
func _message(text := "ERROR", title := "Error!"):
	if guiLayer.get_node("Message"): return
	
	var newMsg = load("res://Data/Editor/Message.tscn").instance()
	guiLayer.add_child(newMsg)
	
	newMsg.desc.text = text
	newMsg.title.text = title
