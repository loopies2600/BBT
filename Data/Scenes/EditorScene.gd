extends Node2D

const FONT := preload("res://Sprites/Font/Main.tres")
const ITEM := preload("res://Data/Editor/EditorItem.tscn")

onready var cursor := $SelectedObject
onready var tilesTab := $GUILayer/GUIViewport/EditorObjects/TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer
onready var itemLabel := $GUILayer/GUIViewport/MenuBar/ItemLabel
onready var viewport := $GUILayer/GUIViewport
onready var utilButtons := $GUILayer/GUIViewport/MenuBar/UtilButtons
onready var cam := $Camera

onready var level := Global.level

var showGrid := false
var showCells := false

func _ready():
	OS.set_window_title("Bennett Boy's Workshop")
	
	Global.editing = true
	
	_spawnTileItems()
	
func _draw():
	var size : Vector2 = get_viewport_rect().size * cam.zoom
	var pos : Vector2 = cam.global_position
	var separation := 16
	
	if showGrid:
		var color := Color.darkgray
		
		for i in range(int((pos.x - size.x) / separation) - 1, int((size.x + pos.x) / separation) + 1):
			draw_line(Vector2(i * separation, pos.y + size.y + 128), Vector2(i * separation, pos.y - size.y - 128), color, 1)
			
		for i in range(int((pos.y - size.y) / separation) - 1, int((size.y + pos.y) / separation) + 1):
			draw_line(Vector2(pos.x + size.x + 128, i * separation), Vector2(pos.x - size.x - 128, i * separation), color, 1)
		
	if showCells:
		for i in range(int((pos.x - size.x) / separation) - 1, int((size.x + pos.x) / separation) + 1):
			draw_string(FONT, Vector2(i * 16, pos.y + size.y - 192), str(i), Color.darkgray)
			
		for i in range(int((pos.y - size.y) / separation) - 1, int((size.y + pos.y) / separation) + 1):
			draw_string(FONT, Vector2(pos.x + size.x - 304, i * 16), str(i), Color.darkgray)
		
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
