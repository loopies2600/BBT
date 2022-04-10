extends "res://Data/Editor/Cursor/CursorMode.gd"

const OBJ_CONFIG := preload("res://Data/Editor/Item/Object/Neo/ObjectConfig.tscn")
const TILE_CONFIG := preload("res://Data/Editor/Item/TileConfig.tscn")

func update():
	get_parent().texture = null
	
func mainClick(_event):
	if !get_parent().canPlace: return
	
	var cell : Vector2 = get_parent().cellPos
	var tgt : TileMap = get_parent().targetTilemap
	var tile := tgt.get_cellv(cell) != -1
	
	if tile:
		_spawnConfigurator(TILE_CONFIG, {"targetMap" : tgt, "targetTile": cell})
	else:
		var n = Main.getNodeOnThisPos(get_parent().cellPos)
		
		if !n: return
		
		var scr
		
		if n.get("CONFIGURATOR"):
			scr = n.get("CONFIGURATOR")
			
		_spawnConfigurator(OBJ_CONFIG, {"target" : n}, scr)

func _spawnConfigurator(config, params := {}, script = null):
	get_parent().configuratorCheck()
	
	get_parent().configurator = config.instance()
	
	if script:
		get_parent().configurator.set_script(script)
		
	for p in params:
		get_parent().configurator.set(p, params[p])
	
	get_parent().get_parent().guiLayer.add_child(get_parent().configurator)
