extends Node2D

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

onready var cursor := $SelectedObject
onready var tilesTab := $GUILayer/EditorObjects/TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer
onready var itemLabel := $GUILayer/MenuBar/ItemLabel
onready var utilButtons := $GUILayer/MenuBar/UtilButtons
onready var cam := $Camera
onready var guiLayer := $GUILayer
onready var aLabel := $HUD/Attempts

onready var level : TileMap = get_tree().get_root().get_node("Main").level

var showGrid := false
var showCells := false
var showCellBox := false

var player : Player

var attempt := 1

func _ready():
	OS.set_window_title("Bennett Boy's Workshop")
	
	get_tree().get_root().get_node("Main").editing = true
	
	_spawnTileItems()
	
func _process(_delta):
	if level:
		if cursor.target.isTile:
			itemLabel.text = level.tile_set.tile_get_name(cursor.target.tileID)
		else:
			itemLabel.text = cursor.target.itemName
		
func _spawnTileItems():
	for tile in level.tile_set.get_tiles_ids():
		var newItem = ITEM.instance()
		
		var tex = level.tile_set.tile_get_texture(tile)
		var region = level.tile_set.tile_get_region(tile)
		
		newItem.selected = tile == 0
		newItem.texture = _tileTexGen(tex, region)
		newItem.tileID = tile
		
		tilesTab.add_child(newItem)
	
func _input(event):
	if event.is_action_pressed("switch_state"):
		_switchStates()
		
func _switchStates():
	level.resetObjectState()
	
	if get_tree().get_root().get_node("Main").editing:
		if !_levelIsValid(): return
		
		level.generateCameraBoundaries()
		level.initializeObjects()
		
		_spawnPlayer()
	else:
		_resetPlayValues()
		
	get_tree().get_root().get_node("Main").editing = !get_tree().get_root().get_node("Main").editing
	cursor.canPlace = get_tree().get_root().get_node("Main").editing
	
func _resetPlayValues():
	if player:
		player.remove_child(cam)
		add_child(cam)
		
		player.queue_free()
		player = null
	
	cam.limit_top = -10000000
	cam.limit_left = -10000000
	cam.limit_bottom = 10000000
	cam.limit_right = 10000000
	
	cam.global_position = Vector2()
	
	attempt = 1
	aLabel.text = "ATTEMPT %s" % attempt
	
func _spawnPlayer():
	var spawn = level.get_node("SpawnPoint")
	
	player = load("res://Data/Player/Player.tscn").instance()
	
	player.levelManager = self
	player.global_position = spawn.global_position
	
	cam.limit_left = level.camBoundariesX.x
	cam.limit_right = level.camBoundariesX.y
	cam.limit_top = level.camBoundariesY.x
	cam.limit_bottom = level.camBoundariesY.y
	
	level.add_child(player)
	
	remove_child(cam)
	player.add_child(cam)
	
func restart():
	attempt += 1
	aLabel.text = "ATTEMPT %s" % attempt
	
	level.resetObjectState()
	level.initializeObjects()
	
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
	
func _tileTexGen(tex : Texture, region : Rect2):
	var atlasTex := AtlasTexture.new()
	var bgTex = TexTool.manipulate(tex, "replaceAlpha", Color.burlywood.darkened(0.125))
	
	atlasTex.atlas = bgTex
	atlasTex.region = region
	
	return atlasTex
