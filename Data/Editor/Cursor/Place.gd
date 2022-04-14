extends "res://Data/Editor/Cursor/CursorMode.gd"

const EXPLOSION := preload("res://Data/Particles/Explosion/Explosion.tscn")

onready var placeSnd := $PlaceObj
onready var removeSnd := $RemoveObj

var brushSize := 1
var explosionRadius := 4

func update():
	get_parent().configuratorCheck()
	if get_parent().target: get_parent().texture = get_parent().target.texture
	
func mainClick(_event):
	if !get_parent().canPlace: return
	
	var tile : bool = get_parent().target.isTile
	var cell : Vector2 = get_parent().cellPos
	var ttm : TileMap = get_parent().targetTilemap
	var tgt = get_parent().target
	var lvl : TileMap = get_parent().level
	
	for y in range(-brushSize, brushSize):
		for x in range(-brushSize, brushSize):
			if (x * x) + (y * y) < (brushSize * brushSize):
				if tile:
					if ttm.get_cellv(cell + Vector2(x, y)) == -1 || ttm.get_cellv(cell) != tgt.tileID:
						placeSnd.play()
						
						if brushSize < 5:
							var placement := preload("res://Data/Particles/TilePlace.tscn").instance()
							lvl.add_child(placement)
							placement.global_position = cell * 16 + Vector2(16 * x, 16 * y)
							
							placement.texture = get_parent().texture
						
					ttm.set_cellv(cell + Vector2(1 * x, 1 * y), tgt.tileID)
					get_parent().emit_signal("tile_placed", cell)
				else:
					if ttm != Main.level: return
					
					var pos := cell + Vector2(1 * x, 1 * y)
					
					var occupied = Main.getNodeOnThisPos(pos) != null
					if occupied: return
					
					placeSnd.play()
						
					var instance = tgt.itemScene.instance()
					
					if _singleInstanceCheck(instance):
						lvl.get_node(instance.name).global_position = (pos * lvl.cell_size).round()
					else:
						instance.global_position = (pos * lvl.cell_size).round()
						instance.add_to_group("Instances")
						
						for p in tgt.customParams:
							instance.set(p, tgt.customParams[p])
						
						lvl.add_child(instance)
						instance.owner = lvl
						
						get_parent().emit_signal("object_placed", pos)

func subClick(_event):
	if !get_parent().canPlace: return
	
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
			
	for y in range(-brushSize, brushSize):
		for x in range(-brushSize, brushSize):
			if (x * x) + (y * y) < (brushSize * brushSize):
				tile = ttm.get_cellv(cell + Vector2(1 * x, 1 * y)) != -1
				
				if tile:
					if exploded: return
					
					removeSnd.play()
					
					if brushSize < 5 && ttm.get_cellv(cell + Vector2(1 * x, 1 * y)) != -1:
						Main.plop(cell * 16 + Vector2(8, 8) + Vector2(16 * x, 16 * y))
					
					Main.level.funnyTileAnim(cell + Vector2(1 * x, 1 * y))
					ttm.set_cellv(cell + Vector2(1 * x, 1 * y), -1)
					
					get_parent().emit_signal("tile_removed", cell)
					
				else:
					if ttm != Main.level: return
					
					var n = Main.getNodeOnThisPos(cell + Vector2(1 * x, 1 * y))
					
					if n:
						removeSnd.play()
					
						if brushSize < 5:
							Main.plop(cell * 16 + Vector2(8, 8) + Vector2(16 * x, 16 * y))
							
						n.queue_free()
						get_parent().emit_signal("object_removed", cell)

func _singleInstanceCheck(inst):
	var exists := false
	
	if get_parent().target.singleInstance:
		exists = true if get_parent().level.get_node(inst.name) != null else false
	
	return exists
