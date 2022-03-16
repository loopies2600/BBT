extends "res://Data/Editor/AntiCursor.gd"

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

onready var tilesTab := $TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer

func _ready():
	yield(owner, "ready")
	
	_spawnTileItems()
	
func _spawnTileItems():
	for tile in Main.level.tile_set.get_tiles_ids():
		var newItem = ITEM.instance()
		
		newItem.selected = tile == 0
		newItem.tileID = tile
		
		tilesTab.add_child(newItem)
	
