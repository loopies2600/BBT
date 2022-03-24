extends "res://Data/Editor/AntiCursor.gd"

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

const DEFPATH := "res://Data/Editor/Definitions/%s.tres"

var Entities := []
var Objects := []

onready var tilesTab := $TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer

func _ready():
	# define objects
	for i in ["Spike", "SpikyBall", "Gravitator", "ConveyorBelt", "BoosterHand", "Text", "Light", "OrbitingPlatforms", "Token", "ToggleButton"]:
		Objects.append(load(DEFPATH % ("Object/%s" % i)))
		
	# define entities
	for i in ["Player", "Earthworm", "Fernandez", "HermitBlob", "Tezoo"]:
		Entities.append(load(DEFPATH % ("Entity/%s" % i)))
	
	yield(owner, "ready")
	
	_spawnTileItems()
	_spawnObjectItems("Objects")
	_spawnObjectItems()
	
func _spawnTileItems():
	for tile in Main.level.tile_set.get_tiles_ids():
		# ignore tile if name starts with "_"
		if Main.level.tile_set.tile_get_name(tile).begins_with("_"):
			return
		
		var newItem = ITEM.instance()
		
		newItem.selected = tile == 0
		newItem.tileID = tile
		
		tilesTab.add_child(newItem)
	
func _spawnObjectItems(def := "Entities"):
	var list : Array = get(def)
	var tab := get_node("TabContainer/%s/ScrollContainer/VBoxContainer/HBoxContainer" % def)
	
	for o in list:
		var newItem = ITEM.instance()
		
		newItem.singleInstance = o.singleInstance
		newItem.isTile = false
		newItem.itemName = o.name
		newItem.texture = o.editorIcon
		newItem.itemScene = o.scene
		
		tab.add_child(newItem)
