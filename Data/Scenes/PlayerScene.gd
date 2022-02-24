extends Node2D

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

onready var cursor := $SelectedObject
onready var tilesTab := $GUILayer/EditorObjects/TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer
onready var utilButtons := $GUILayer/MenuBar/UtilButtons
onready var cam := $Camera
onready var guiLayer := $GUILayer
onready var desc := $GUILayer/Descriptor

onready var level : TileMap = Main.level

var showGrid := false
var showCells := false
var showCellBox := false

var player : Player

func _ready():
	OS.set_window_title("Bennett Boy's Workshop")
	
	Main.editing = true
	
	_spawnTileItems()
	
func _process(_delta):
	if Main.editing:
		Main.entityLookTowards = get_global_mouse_position()
	
	# scroll BG
	Main.background.scroll_offset = get_canvas_transform().origin
	
func _spawnTileItems():
	for tile in level.tile_set.get_tiles_ids():
		var newItem = ITEM.instance()
		
		newItem.selected = tile == 0
		newItem.tileID = tile
		
		tilesTab.add_child(newItem)
	
func _input(event):
	if event.is_action_pressed("switch_state"):
		_switchStates()
		
func _switchStates():
	cam.global_position = Vector2()
	
	level.resetObjectState()
	
	if Main.editing:
		if !_levelIsValid(): return
		
		if cursor.configurator:
			cursor.configurator.queue_free()
			cursor.configurator = null
		
		level.initializeObjects()
		level.copyMap()
		
		_spawnPlayer()
	else:
		level.restoreMap()
		
		_resetPlayValues()
		cam.current = true
		
	Main.editing = !Main.editing
	cursor.canPlace = Main.editing
	
func _resetPlayValues():
	if player:
		player.queue_free()
		player = null
		
	Main.attempt = 1
	Main.hud.aLabel.text = "ATTEMPT %s" % Main.attempt
	
func _spawnPlayer():
	var spawn = level.get_node("SpawnPoint")
	
	player = load("res://Data/Player/Player.tscn").instance()
	
	player.levelManager = self
	player.global_position = spawn.global_position
	
	level.add_child(player)
	
func restart():
	Main.attempt += 1
	Main.hud.aLabel.text = "ATTEMPT %s" % Main.attempt
	
	level.resetObjectState()
	level.initializeObjects()
	level.restoreMap()
	
	player.letsStart()
	
func _levelIsValid() -> bool:
	var hasSpawnPoint := false
	var hasTiles := level.get_used_cells().size() != 0
	
	for c in level.get_children():
		if c.name == "SpawnPoint":
			hasSpawnPoint = true
	
	if !hasTiles:
		_message("Level is empty")
		return false
	
	if !hasSpawnPoint: 
		_message("No player spawn point") 
		return false
		
	return true
		
func _message(text := "ERROR"):
	if guiLayer.get_node("Message"): return
	
	var newMsg = load("res://Data/Editor/Message.tscn").instance()
	guiLayer.add_child(newMsg)
	newMsg.desc.text = text
