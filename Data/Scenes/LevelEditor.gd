extends Node2D

onready var cursor := $Cursor
onready var utilButtons := $GUILayer/Sidebar/UtilButtons
onready var cam : Camera2D = Main.cam
onready var guiLayer := $GUILayer
onready var desc := $GUILayer/Descriptor

var showGrid := false
var showCells := false

var bgTex : Texture

func _ready():
	OS.set_window_title("Bennett Boy's Workshop")
	
	Main.ot.setTouchControls(true)
	Main.editing = true
	Main.cam.current = true
	Main.cam.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	
	yield(get_tree(), "idle_frame")
	Main.cam.global_position = Vector2(213, 120)
	
func _process(_delta):
	if Main.editing:
		Main.entityLookTowards = cursor.get_global_mouse_position()
	
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
	else:
		Main.level.restoreMap()
		
		_resetPlayValues()
		
		if Main.level.get("mus"):
			Main.level.mus.stop()
		
		var camPos := Vector2.ZERO
		
		if Main.level.get_node("Player"):
			camPos = Main.level.get_node("Player").global_position
		
		Main.cam.global_position = camPos
		
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
