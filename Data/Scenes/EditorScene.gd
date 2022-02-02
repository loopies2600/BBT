extends Node2D

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

onready var cursor := $SelectedObject
onready var level := $LevelLayout
onready var tilesTab := $GUILayer/EditorObjects/TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer
onready var itemLabel := $GUILayer/MenuBar/ItemLabel

func _ready():
	_spawnTileItems()
	
func _process(_delta):
	if cursor.isTile:
		itemLabel.text = level.tile_set.tile_get_name(cursor.tileID)
	else:
		itemLabel.text = cursor.itemName
	
func _spawnTileItems():
	for tile in level.tile_set.get_tiles_ids():
		var newItem = ITEM.instance()
		
		var tex = level.tile_set.tile_get_texture(tile)
		var region = level.tile_set.tile_get_region(tile)
		
		newItem.selected = tile == 0
		newItem.texture = _tileTexGen(tex, region)
		newItem.tileID = tile
		
		tilesTab.add_child(newItem)
	
func _tileTexGen(tex : Texture, region : Rect2):
	var atlasTex := AtlasTexture.new()
	var bgTex = TexTool.manipulate(tex, "replaceAlpha", Color.burlywood.darkened(0.125))
	
	atlasTex.atlas = bgTex
	atlasTex.region = region
	
	return atlasTex
