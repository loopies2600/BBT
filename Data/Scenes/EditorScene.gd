extends Node2D

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

onready var cursor := $SelectedObject
onready var level := $LevelLayout
onready var tilesTab := $GUILayer/GUIViewport/EditorObjects/TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer
onready var itemLabel := $GUILayer/GUIViewport/MenuBar/ItemLabel
onready var viewport := $GUILayer/GUIViewport

func _ready():
	OS.set_window_title("Bennett Boy's Workshop")
	
	Global.editing = true
	
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
	viewport.input(event)
	
	if event.is_action_pressed("switch_state"):
		_playTest()
		
func _playTest():
	var hasSpawnPoint := false
	var hasTiles = level.get_used_cells().size() != 0
	
	for c in level.get_children():
		if c.name == "SpawnPoint":
			hasSpawnPoint = true
		
	if !hasTiles:
		_message("Level is empty")
		return
	
	if !hasSpawnPoint: 
		_message("No player spawn point") 
		return
		
	var mapPack = PackedScene.new()
	var err = mapPack.pack(level)
	
	if err == OK:
		Global.playLevel(mapPack)
	
func _message(text := "ERROR"):
	if viewport.get_node("Message"): return
	
	var newMsg = load("res://Data/Editor/Message.tscn").instance()
	viewport.add_child(newMsg)
	newMsg.desc.text = text
	
func _tileTexGen(tex : Texture, region : Rect2):
	var atlasTex := AtlasTexture.new()
	var bgTex = TexTool.manipulate(tex, "replaceAlpha", Color.burlywood.darkened(0.125))
	
	atlasTex.atlas = bgTex
	atlasTex.region = region
	
	return atlasTex
