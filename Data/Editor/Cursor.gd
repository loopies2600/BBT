extends Sprite

const OBJ_CONFIG := preload("res://Data/Editor/Item/Object/ObjectConfig.tscn")
const TILE_CONFIG := preload("res://Data/Editor/Item/TileConfig.tscn")

enum Modes {PLACE, MOVE, CONFIG}

onready var level : TileMap = Main.level
onready var targetTilemap := level
onready var sounds := [$PlaceObj, $RemoveObj]

var mode = Modes.PLACE

var canPlace := true

var configurator
var holding
var target

var rotating := false
var alreadyPressed := false

var cellPos := Vector2()

func _process(_delta):
	rotating = Input.is_action_pressed("mouse_secondary")
	
	var result : Vector2 = (_frickinPositionFormula() / level.cell_size).round() * level.cell_size
	
	if !Main.editing:
		texture = null
		return
		
	if canPlace:
		global_position = result
		cellPos = ((global_position / level.cell_size).round() / level.scale).round()
	
	match mode:
		Modes.PLACE:
			_configuratorCheck()
			if target: texture = target.texture
		Modes.MOVE:
			texture = null
			_configuratorCheck()
		Modes.CONFIG:
			texture = null
	
func _frickinPositionFormula() -> Vector2:
	var mousePos := get_global_mouse_position()
	var cursorOffset := Vector2(8, 8)
	
	var result : Vector2 = (((mousePos - cursorOffset) / level.cell_size).round()  / level.scale).round() * level.cell_size
	
	return result
	
func _configuratorCheck():
	if configurator:
		configurator.queue_free()
		configurator = null
	
func _input(event):
	if !Main.editing:
		return
		
	match mode:
		Modes.PLACE:
			if canPlace:
				if Input.is_action_pressed("mouse_main"):
					if target.isTile:
						if targetTilemap.get_cellv(cellPos) == -1 || targetTilemap.get_cellv(cellPos) != target.tileID:
							var placement := preload("res://Data/Particles/TilePlace.tscn").instance()
							level.add_child(placement)
							placement.global_position = cellPos * 16
							
							placement.texture = texture
							
							targetTilemap.set_cellv(cellPos, target.tileID)
							sounds[0].play()
					else:
						var occupied := _getNodeOnThisPos() != null
						if occupied: return
						
						sounds[0].play()
					
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
					var isTile := targetTilemap.get_cellv(cellPos) != -1
					
					if isTile:
						if Input.is_action_pressed("special"):
							var explosion := preload("res://Data/Particles/Explosion/Explosion.tscn").instance()
							explosion.global_position = cellPos * 16
							get_parent().add_child(explosion)
							
							level.purgeCircle(cellPos, 4, -1, targetTilemap)
						else:
							sounds[1].play()
							
							targetTilemap.set_cellv(cellPos, -1)
							Main.plop(cellPos * 16 + Vector2(8, 8))
					else:
						var n = _getNodeOnThisPos()
						
						if n:
							sounds[1].play()
							Main.plop(cellPos * 16 + Vector2(8, 8))
							
							n.queue_free()
		Modes.MOVE:
			if canPlace:
				if event.is_action_pressed("mouse_main"):
					holding = _getNodeOnThisPos()
				if event.is_action_released("mouse_main"):
					holding = null
					
				if event is InputEventMouseMotion:
					if !holding: return
					
					if rotating:
						var amt : float = event.relative.y * 0.025
						
						if holding.get("_editorRotate"):
							holding.get("_editorRotate").rotation += amt
						else:
							holding.rotation += amt
					else:
						holding.global_position = (event.position - get_canvas_transform().origin) * get_parent().cam.zoom
						holding.global_position = (holding.global_position / level.cell_size).round() * level.cell_size
						
						if holding.get("spawnPos"):
							holding.spawnPos = holding.global_position
					
		Modes.CONFIG:
			if canPlace:
				if Input.is_action_just_pressed("mouse_main"):
					var isTile := level.get_cellv(cellPos) != -1
					
					if !isTile:
							var n = _getNodeOnThisPos()
							if !n: return
							
							var cfg = OBJ_CONFIG
						
							if n.get("CONFIGURATOR"):
								cfg = n.get("CONFIGURATOR")
							
							_spawnConfigurator(cfg, {"target" : n})
					else:
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
