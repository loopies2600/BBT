extends "res://Data/Editor/AntiCursor.gd"

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

const DEFPATH := "res://Data/Editor/Definitions/%s.tres"

var Entities := []
var Objects := []
var PowerUps := []

onready var tilesTab := $TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer

func _ready():
	# define objects
	print("--- OBJECT LIST ---")
	for i in ["Spike", "SpikyBall", "Gravitator", "ConveyorBelt", "BoosterHand", "Text", "Light", "OrbitingPlatforms", "Token", "ToggleButton"]:
		print(i, " registered")
		Objects.append(load(DEFPATH % ("Object/%s" % i)))
		
	print("")
	
	# define entities
	print("--- ENTITY LIST ---")
	for i in ["Player", "Earthworm", "Fernandez", "HermitBlob", "Tezoo", "Planisandro"]:
		print(i, " registered")
		Entities.append(load(DEFPATH % ("Entity/%s" % i)))
	print("")
	
	# define powerups (TEMP)
	print("--- POWERUP LIST ---")
	for i in ["Rocket"]:
		print(i, " registered")
		PowerUps.append(load(DEFPATH % ("PowerUp/%s" % i)))
	print("")
	
	yield(owner, "ready")
	
	_spawnTileItems()
	_spawnObjectItems("Objects")
	_spawnObjectItems()
	_spawnObjectItems("PowerUps")
	
func _spawnTileItems():
	for tile in Main.level.tile_set.get_tiles_ids():
		# ignore tile if name starts with "_"
		if !Main.level.tile_set.tile_get_name(tile).begins_with("_"):
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
