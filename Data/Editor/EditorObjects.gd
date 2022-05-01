extends "res://Data/Editor/AntiCursor.gd"

const ITEM := preload("res://Data/Editor/EditorItem.tscn")

const DEFPATH := "res://Data/Editor/Definitions/%s.tres"

var Entities := []
var Objects := []
var Markers := []
var PowerUps := []

onready var tilesTab := $TabContainer/Tiles/ScrollContainer/VBoxContainer/HBoxContainer

func _ready():
	for i in ["Spike", "SpikyBall", "Gravitator", "ConveyorBelt", "BoosterHand", "Text", "Light", "OrbitingPlatforms", "Token", "ToggleButton", "PointingArrow", "PureColor", "TimerToggleButton", "DoorButton", "Bridge"]:
		Objects.append(load(DEFPATH % ("Object/%s" % i)))
		
	for i in ["Player", "Earthworm", "Fernandez", "HermitBlob", "Tezoo", "Planisandro", "Midget", "Sunny"]:
		Entities.append(load(DEFPATH % ("Entity/%s" % i)))
		
	for i in ["LockCam"]:
		Markers.append(load(DEFPATH % ("Marker/%s" % i)))
		
	for i in ["Rocket"]:
		PowerUps.append(load(DEFPATH % ("PowerUp/%s" % i)))
		
	yield(owner, "ready")
	
	_spawnTileItems()
	_spawnObjectItems()
	_spawnObjectItems("Entities")
	_spawnObjectItems("Markers")
	_spawnObjectItems("PowerUps")
	
func _spawnTileItems():
	for tile in Main.level.tile_set.get_tiles_ids():
		# ignore tile if name starts with "_"
		if !Main.level.tile_set.tile_get_name(tile).begins_with("_"):
			var tTab = tilesTab
			
			var newItem = ITEM.instance()
			
			newItem.selected = tile == 0
			newItem.tileID = tile
			
			if tile in [61, 62, 77, 79]:
				tTab = $TabContainer/Objects/ScrollContainer/VBoxContainer/HBoxContainer
				
			tTab.add_child(newItem)
	
func _spawnObjectItems(def := "Objects"):
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
