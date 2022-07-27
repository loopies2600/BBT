extends "res://Data/Editor/Cursor/CursorMode.gd"

const OBJ_CONFIG := preload("res://Data/Editor/Item/Object/Neo/ObjectConfig.tscn")
const TILE_CONFIG := preload("res://Data/Editor/Item/TileConfig.tscn")

func update():
	get_parent().texture = null
	
func mainClick(_event):
	if !get_parent().canPlace: return
	
	var cell : Vector2 = get_parent().cellPos
	var ttm : TileMap = get_parent().targetTilemap
	var tile := ttm.get_cellv(cell * Main.cellSize) != -1
	
	if tile:
		_spawnConfigurator(TILE_CONFIG, {"targetMap" : ttm, "targetTile": cell})
	else:
		if ttm != Main.level: return
		
		var n = Main.getNodeOnThisPos(get_parent().cellPos * Main.cellSize)
		
		if !n: return
		
		var scr
		
		if n.get("CONFIGURATOR"):
			scr = n.get("CONFIGURATOR")
			
		_spawnConfigurator(OBJ_CONFIG, {"target" : n}, scr)

func _spawnConfigurator(config, params := {}, script = null):
	var alreadyOpen : bool = get_parent().configuratorCheck()
	
	get_parent().configurator = config.instance()
	
	if script:
		get_parent().configurator.set_script(script)
		
	for p in params:
		get_parent().configurator.set(p, params[p])
		
	get_parent().get_parent().guiLayer.add_child(get_parent().configurator)
	
	if alreadyOpen: get_parent().configurator.get_node("Animator").play("RESET")
