extends Node2D

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

onready var cursor := $SelectedObject
onready var level := $LevelLayout
onready var tilesTab := $EditorObjects/TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer

func _ready():
	_spawnTileItems()
	
func _spawnTileItems():
	for tile in level.tile_set.get_tiles_ids():
		var newItem = ITEM.instance()
		
		var tex = level.tile_set.tile_get_texture(tile)
		var region = level.tile_set.tile_get_region(tile)
		
		newItem.texture = _tileTexGen(tex, region)
		newItem.tileID = tile
		newItem.cursor = cursor
		
		tilesTab.add_child(newItem)
	
func _tileTexGen(tex : Texture, region : Rect2):
	var atlasTex := AtlasTexture.new()
	var bgTex = TexTool.manipulate(tex, "replaceAlpha", Color.burlywood.darkened(0.125))
	
	atlasTex.atlas = bgTex
	atlasTex.region = region
	
	return atlasTex
