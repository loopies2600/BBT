extends Node2D

const FONT := preload("res://Sprites/Font/Main.tres")
const ITEM := preload("res://Data/Editor/EditorItem.tscn")

onready var cursor := $SelectedObject
onready var tilesTab := $GUILayer/GUIViewport/EditorObjects/TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer
onready var itemLabel := $GUILayer/GUIViewport/MenuBar/ItemLabel
onready var viewport := $GUILayer/GUIViewport
onready var utilButtons := $GUILayer/GUIViewport/MenuBar/UtilButtons
onready var cam := $Camera

onready var level : TileMap = Global.level

var showGrid := false
var showCells := false
var showCellBox := false

func _ready():
	OS.set_window_title("Bennett Boy's Workshop")
	
	Global.editing = true
	level.resetObjectState()
	
	_spawnTileItems()
	
func _draw():
	var size : Vector2 = get_viewport_rect().size * cam.zoom
	var pos : Vector2 = cam.global_position
	var separation := level.cell_size * level.scale
	var limit := Vector2(320, 224) * level.scale
	
	if showGrid:
		var color := Color.darkgray
		
		for i in range(int((pos.x - size.x) / separation.x) - 1, int((size.x + pos.x) / separation.x) + 1):
			draw_line(Vector2(i * separation.x, pos.y + size.y + limit.x), Vector2(i * separation.x, pos.y - size.y - limit.x), color, 1)
			
		for i in range(int((pos.y - size.y) / separation.y) - 1, int((size.y + pos.y) / separation.y) + 1):
			draw_line(Vector2(pos.x + size.x + limit.y, i * separation.y), Vector2(pos.x - size.x - limit.y, i * separation.y), color, 1)
		
	if showCells:
		for i in range(int((pos.x - size.x) / separation.x) - 1, int((size.x + pos.x) / separation.x) + 1):
			draw_string(FONT, Vector2(i * separation.x, pos.y + size.y - 192), str(i), Color.darkgray)
			
		for i in range(int((pos.y - size.y) / separation.x) - 1, int((size.y + pos.y) / separation.x) + 1):
			draw_string(FONT, Vector2(pos.x + size.x - 304, i * separation.y), str(i), Color.darkgray)
		
	if showCellBox:
		for c in level.get_used_cells():
			draw_rect(Rect2(Vector2(c.x, c.y) * level.cell_size * level.scale, level.cell_size * level.scale), Color(0.66, 0.66, 0.66, 0.5), true)
			
		for n in level.get_children():
			draw_rect(Rect2(n.global_position * level.scale, level.cell_size * level.scale), Color(0.66, 0.66, 0.66, 0.5), true)
		
	if cursor.configurator:
		draw_rect(Rect2(cursor.configurator.targetTile * level.cell_size * level.scale, level.cell_size * level.scale), Color.tomato, false, 2)
		
func _process(_delta):
	update()
	
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
		
	level.generateCameraBoundaries()
	Global.playLevel()
	
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
