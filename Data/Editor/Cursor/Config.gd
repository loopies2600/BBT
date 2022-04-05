extends "res://Data/Editor/Cursor/CursorMode.gd"

const OBJ_CONFIG := preload("res://Data/Editor/Item/Object/ObjectConfig.tscn")
const TILE_CONFIG := preload("res://Data/Editor/Item/TileConfig.tscn")

func update():
	get_parent().texture = null
	get_parent().scale = Vector2.ONE
	
func mainClick(_event):
	if !get_parent().canPlace: return
	
	var cell : Vector2 = get_parent().cellPos
	var tgt : TileMap = get_parent().targetTilemap
	var tile := tgt.get_cellv(cell) != -1
	
	if tile:
		_spawnConfigurator(TILE_CONFIG, {"targetMap" : tgt, "targetTile": cell})
	else:
		var n = get_parent().getNodeOnThisPos()
		
		if !n: return
		
		var cfg = OBJ_CONFIG
		
		if n.get("CONFIGURATOR"):
			cfg = n.get("CONFIGURATOR")
			
		_spawnConfigurator(cfg, {"target" : n})

func _spawnConfigurator(config, params := {}):
	get_parent().configuratorCheck()
	
	get_parent().configurator = config.instance()
	
	for p in params:
		get_parent().configurator.set(p, params[p])
	
	get_parent().get_parent().guiLayer.add_child(get_parent().configurator)
