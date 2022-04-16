extends "res://Data/Editor/Cursor/CursorMode.gd"

const EXPLOSION := preload("res://Data/Particles/Explosion/Explosion.tscn")

onready var placeSnd := $PlaceObj
onready var removeSnd := $RemoveObj

var basePlaceOptions := {
	"flip_x": false,
	"flip_y": false,
	"transpose": false,
	"rotation_degrees": 0.0,
	"scale:x": 1.0,
	"scale:y": 1.0
	}
	
var brushSize := 1
var explosionRadius := 4
var floodFill := false

func update():
	get_parent().configuratorCheck()
	if get_parent().target: get_parent().texture = get_parent().target.texture
	
func _getCellsInRadius(cell := Vector2()) -> Array:
	var cells := []
	
	for y in range(-brushSize, brushSize):
		for x in range(-brushSize, brushSize):
			if (x * x) + (y * y) < (brushSize * brushSize):
				cells.append(cell + Vector2(x, y))
		
	return cells
	
func mainClick(_event):
	if !get_parent().canPlace: return
	
	var tile : bool = get_parent().target.isTile
	var cell : Vector2 = get_parent().cellPos
	var ttm : TileMap = get_parent().targetTilemap
	var tgt = get_parent().target
	var lvl : TileMap = get_parent().level
	
	var availableTiles := _getCellsInRadius(cell)
	
	if floodFill: availableTiles = Main.level.floodFill(cell, 32, ttm, [-1, ttm.get_cellv(cell)])
	
	for t in availableTiles:
		if tile:
			if ttm.get_cellv(t) == -1 || ttm.get_cellv(cell) != tgt.tileID:
				placeSnd.play()
			
			ttm.set_cellv(t, tgt.tileID, basePlaceOptions.flip_x, basePlaceOptions.flip_y, basePlaceOptions.transpose)
			get_parent().emit_signal("tile_placed", cell)
		else:
			if ttm != Main.level: return
			
			var pos : Vector2 = t
					
			var occupied = Main.getNodeOnThisPos(pos) != null
			if occupied: return
					
			placeSnd.play()
				
			var instance = tgt.itemScene.instance()
			
			if _singleInstanceCheck(instance):
				var inst = lvl.get_node(instance.name)
				
				inst.global_position = (pos * lvl.cell_size).round()
				
				if inst.get("spawnPos"):
					inst.spawnPos = inst.global_position
			else:
				instance.global_position = (pos * lvl.cell_size).round()
				instance.add_to_group("Instances")
				
				for p in tgt.customParams:
					instance.set(p, tgt.customParams[p])
				
				lvl.add_child(instance)
				instance.owner = lvl
				
				get_parent().emit_signal("object_placed", pos)
				
			instance.scale.x = basePlaceOptions["scale:x"]
			instance.scale.y = basePlaceOptions["scale:y"]
			
			var rotationTarget = instance
			
			if instance.get("_editorRotate"): rotationTarget = instance._editorRotate
			
			rotationTarget.rotation_degrees = basePlaceOptions.rotation_degrees

func subClick(event):
	if !get_parent().canPlace: return
	
	var mot := Vector2()
	
	if event is InputEventMouseMotion:
		mot = event.relative
		
	var cell : Vector2 = get_parent().cellPos
	var ttm : TileMap = get_parent().targetTilemap
	var tile := ttm.get_cellv(cell) != -1
	var lvl : TileMap = get_parent().level
	
	var exploded := false
	
	if Input.is_action_pressed("special"):
		if ttm.get_cellv(cell) != -1:
			var explosion := EXPLOSION.instance()
			explosion.global_position = cell * 16
			ttm.add_child(explosion)
			
			lvl.purgeCircle(cell, explosionRadius, -1, ttm)
			
			get_parent().emit_signal("tile_removed", cell)
			exploded = true
		
	var availableTiles := _getCellsInRadius(cell)
	
	if floodFill: availableTiles = Main.level.floodFill(cell, 32, ttm, [-1, ttm.get_cellv(cell)])
	
	for t in availableTiles:
		tile = ttm.get_cellv(t) != -1
		
		if tile:
			if exploded: return
			
			removeSnd.play()
			
			if brushSize < 5 && ttm.get_cellv(t) != -1:
				Main.plop(Vector2(8, 8) + t * 16)
				
			Main.level.funnyTileAnim(t, Vector2(256 * sin(mot.x), rand_range(-256, -512)))
			ttm.set_cellv(t, -1)
			
			get_parent().emit_signal("tile_removed", cell)
			
		else:
			if ttm != Main.level: return
			
			var n = Main.getNodeOnThisPos(t)
			
			if n:
				removeSnd.play()
				
				Main.plop(Vector2(8, 8) + t * 16)
					
				n.queue_free()
				get_parent().emit_signal("object_removed", cell)

func _singleInstanceCheck(inst):
	var exists := false
	
	if get_parent().target.singleInstance:
		exists = true if get_parent().level.get_node(inst.name) != null else false
	
	return exists
