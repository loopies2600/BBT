extends Sprite

const OBJ_CONFIG := preload("res://Data/Editor/Item/Object/ObjectConfig.tscn")
const TILE_CONFIG := preload("res://Data/Editor/Item/TileConfig.tscn")

enum Modes {PLACE, CONFIG}
var mode = Modes.PLACE

var canPlace := true

var configurator
var target

var alreadyPressed := false

var cellPos := Vector2()

onready var level : TileMap = Main.level

func _process(_delta):
	var result : Vector2 = (_frickinPositionFormula() / level.cell_size).round() * level.cell_size
	
	if !Main.editing:
		texture = null
		return
		
	mode = _getMode()
	
	if canPlace:
		global_position = result
		cellPos = ((global_position / level.cell_size).round() / level.scale).round()
	
func _frickinPositionFormula() -> Vector2:
	var mousePos := get_global_mouse_position()
	var cursorOffset := Vector2(8, 8)
	
	var result : Vector2 = (((mousePos - cursorOffset) / level.cell_size).round()  / level.scale).round() * level.cell_size
	
	return result
	
func _getMode():
	var activeButtonIdx := 0
	
	for c in range(get_parent().utilButtons.get_child_count()):
		var b = get_parent().utilButtons.get_child(c)
		
		if b.is_in_group("Refresh"):
			if b.pressed:
				activeButtonIdx = c
		
	return activeButtonIdx
	
func _configuratorCheck():
	if configurator:
		configurator.queue_free()
		configurator = null
	
func _input(event):
	if !Main.editing:
		return
		
	match mode:
		Modes.PLACE:
			_configuratorCheck()
				
			if target: texture = target.texture
			
			if canPlace:
				if Input.is_action_pressed("mouse_main"):
					if target.isTile:
						level.set_cellv(cellPos, target.tileID)
					else:
						var occupied := _getNodeOnThisPos() != null
						if occupied: return
						
						var instance = target.itemScene.instance()
						
						if _singleInstanceCheck(instance):
							level.get_node(instance.name).global_position = (cellPos * level.cell_size).round()
						else:
							instance.global_position = (cellPos * level.cell_size).round()
							instance.add_to_group("Instances")
							
							for p in target.customParams:
								instance.set(p, target.customParams[p])
								
							level.add_child(instance)
							instance.owner = level
					
				if Input.is_action_pressed("mouse_secondary"):
					var isTile := level.get_cellv(cellPos) != -1
					
					if isTile:
						level.set_cellv(cellPos, -1)
					else:
						var n = _getNodeOnThisPos()
						
						if n:
							n.queue_free()
		Modes.CONFIG:
			texture = null
			
			if canPlace:
				var dir = int(Input.is_action_just_pressed("mouse_main")) - int(Input.is_action_just_pressed("mouse_secondary"))
				
				var isTile := level.get_cellv(cellPos) != -1
				
				if !isTile:
					if Input.is_action_just_pressed("mouse_main"):
						var n = _getNodeOnThisPos()
						if !n: return
						
						var cfg = OBJ_CONFIG
					
						if n.get("CONFIGURATOR"):
							cfg = n.get("CONFIGURATOR")
						
						_spawnConfigurator(cfg, {"target" : n})
				else:
					if Input.is_action_just_pressed("mouse_main"):
						_spawnConfigurator(TILE_CONFIG, {"targetTile": cellPos})
		
func _spawnConfigurator(config, params := {}):
	if configurator: 
		configurator.queue_free()
		configurator = null 
	
	configurator = config.instance()
	
	for p in params:
		configurator.set(p, params[p])
	
	get_parent().guiLayer.add_child(configurator)
	
func _singleInstanceCheck(inst):
	var exists := false
	
	if target.singleInstance:
		exists = true if level.get_node(inst.name) != null else false
	
	return exists
	
func _getNodeOnThisPos() -> Node2D:
	var node
	
	for c in get_tree().get_nodes_in_group("Instances"):
		if (c.global_position / level.cell_size / level.scale).round() == cellPos:
			node = c
	
	return node
