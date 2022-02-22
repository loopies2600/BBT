extends Node2D

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

onready var cursor := $SelectedObject
onready var tilesTab := $GUILayer/EditorObjects/TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer
onready var itemLabel := $GUILayer/MenuBar/ItemLabel
onready var utilButtons := $GUILayer/MenuBar/UtilButtons
onready var cam := $Camera
onready var guiLayer := $GUILayer

onready var level : TileMap = get_tree().get_root().get_node("Main").level

var showGrid := false
var showCells := false
var showCellBox := false

var player : Player

func _ready():
	OS.set_window_title("Bennett Boy's Workshop")
	
	get_tree().get_root().get_node("Main").editing = true
	
	_spawnTileItems()
	
func _process(_delta):
	# scroll BG
	get_tree().get_root().get_node("Main").background.scroll_offset = get_canvas_transform().origin
	
	if level:
		if cursor.target.isTile:
			itemLabel.text = level.tile_set.tile_get_name(cursor.target.tileID)
		else:
			itemLabel.text = cursor.target.itemName
		
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
	
	if get_tree().get_root().get_node("Main").editing:
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
		
	get_tree().get_root().get_node("Main").editing = !get_tree().get_root().get_node("Main").editing
	cursor.canPlace = get_tree().get_root().get_node("Main").editing
	
func _resetPlayValues():
	if player:
		player.queue_free()
		player = null
		
	get_tree().get_root().get_node("Main").attempt = 1
	get_tree().get_root().get_node("Main").hud.aLabel.text = "ATTEMPT %s" % get_tree().get_root().get_node("Main").attempt
	
func _spawnPlayer():
	var spawn = level.get_node("SpawnPoint")
	
	player = load("res://Data/Player/Player.tscn").instance()
	
	player.levelManager = self
	player.global_position = spawn.global_position
	
	level.add_child(player)
	
func restart():
	get_tree().get_root().get_node("Main").attempt += 1
	get_tree().get_root().get_node("Main").hud.aLabel.text = "ATTEMPT %s" % get_tree().get_root().get_node("Main").attempt
	
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
