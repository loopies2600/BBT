extends "res://Data/Editor/AntiCursor.gd"

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

const ENTITIES := [preload("res://Data/Editor/Definitions/Entity/Player.tres"), preload("res://Data/Editor/Definitions/Entity/Earthworm.tres"), preload("res://Data/Editor/Definitions/Entity/Fernandez.tres"), preload("res://Data/Editor/Definitions/Entity/HermitBlob.tres"), preload("res://Data/Editor/Definitions/Entity/Tezoo.tres")]
const OBJECTS := [preload("res://Data/Editor/Definitions/Object/Spike.tres"), preload("res://Data/Editor/Definitions/Object/SpikyBall.tres"), preload("res://Data/Editor/Definitions/Object/Gravitator.tres"), preload("res://Data/Editor/Definitions/Object/ConveyorBelt.tres"), preload("res://Data/Editor/Definitions/Object/BoosterHand.tres"), preload("res://Data/Editor/Definitions/Object/Text.tres"), preload("res://Data/Editor/Definitions/Object/Light.tres"), preload("res://Data/Editor/Definitions/Object/OrbitingPlatforms.tres"), preload("res://Data/Editor/Definitions/Object/Token.tres")]

onready var tilesTab := $TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer

func _ready():
	yield(owner, "ready")
	
	_spawnTileItems()
	_spawnObjectItems("Objects")
	_spawnObjectItems()
	
func _spawnTileItems():
	for tile in Main.level.tile_set.get_tiles_ids():
		var newItem = ITEM.instance()
		
		newItem.selected = tile == 0
		newItem.tileID = tile
		
		tilesTab.add_child(newItem)
	
func _spawnObjectItems(def := "Entities"):
	var list : Array = get(def.to_upper())
	var tab := get_node("TabContainer/%s/ScrollContainer/VBoxContainer/HBoxContainer" % def)
	
	for o in list:
		var newItem = ITEM.instance()
		
		newItem.singleInstance = o.singleInstance
		newItem.isTile = false
		newItem.itemName = o.name
		newItem.texture = o.editorIcon
		newItem.itemScene = o.scene
		
		tab.add_child(newItem)
