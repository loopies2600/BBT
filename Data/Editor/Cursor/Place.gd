extends "res://Data/Editor/Cursor/CursorMode.gd"

onready var placeSnd := $PlaceObj
onready var removeSnd := $RemoveObj

var basePlaceOptions := {
	"flip_x": false,
	"flip_y": false,
	"transpose": false,
	"rotation_degrees": 0.0,
	"scale:x": 1.0,
	"scale:y": 1.0,
	"modulate:r": 1.0,
	"modulate:g": 1.0,
	"modulate:b": 1.0
	}
	
var brushSize := 1
var floodFill := false

func update():
	get_parent().configuratorCheck()
	if get_parent().target: get_parent().texture = get_parent().target.texture
	
func _getCellsInRadius(cell := Vector2(), radius := brushSize) -> Array:
	var cells := []
	
	for y in range(-radius, radius):
		for x in range(-radius, radius):
			if (x * x) + (y * y) < (radius * radius):
				cells.append(cell + Vector2(x, y))
		
	return cells
	
func mainClick(_event):
	if !get_parent().canPlace: return
	
	var action := {}
	
	var tile : bool = get_parent().target.isTile
	var cell : Vector2 = get_parent().cellPos
	var ttm : TileMap = get_parent().targetTilemap
	var tgt = get_parent().target
	var lvl : TileMap = Main.level
	
	var availableTiles := _getCellsInRadius(cell)
	
	if floodFill: availableTiles = Main.level.floodFill(cell, 32, ttm, [-1, ttm.get_cellv(cell)])
	
	action = _actionGen(availableTiles, ttm, [tgt.tileID])
	
	for entry in action:
		action[entry].id = tgt.tileID
		
	if !action.empty(): get_parent().tilePlacingHistory.append(action)
	
	for t in availableTiles:
		if tile:
			if ttm.get_cellv(t) == -1 || ttm.get_cellv(cell) != tgt.tileID:
				placeSnd.play()
			
			ttm.set_cellv(t, tgt.tileID, basePlaceOptions.flip_x, basePlaceOptions.flip_y, basePlaceOptions.transpose)
			get_parent().emit_signal("tile_placed", cell)
			
			if ttm in [Main.level, Main.level.tmBg]:
				Main.level.redrawShadows()
		else:
			if ttm != Main.level: return
			
			var pos : Vector2 = t
					
			var occupied = Main.getNodeOnThisPos(pos)
			
			if occupied:
				if occupied.has_method("clickEvent"):
					occupied.clickEvent()
				
				return
				
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
				
				if instance.has_method("resetState"):
					var _unused = lvl.connect("state_reset", instance, "resetState")
				
				get_parent().emit_signal("object_placed", pos)
				
			instance.scale.x = basePlaceOptions["scale:x"]
			instance.scale.y = basePlaceOptions["scale:y"]
			instance.modulate = Color(basePlaceOptions["modulate:r"], basePlaceOptions["modulate:g"], basePlaceOptions["modulate:b"], 1.0)
			
			var rotationTarget = instance
			
			if instance.get("_editorRotate"): rotationTarget = instance._editorRotate
			
			rotationTarget.rotation_degrees = basePlaceOptions.rotation_degrees
	
func subClick(event):
	if !get_parent().canPlace: return
	
	var action := {}
	
	var mot := Vector2()
	
	if event is InputEventMouseMotion:
		mot = event.relative
		
	var cell : Vector2 = get_parent().cellPos
	var ttm : TileMap = get_parent().targetTilemap
	var tile := ttm.get_cellv(cell) != -1
	
	var availableTiles := _getCellsInRadius(cell)
	
	if floodFill: availableTiles = Main.level.floodFill(cell, 32, ttm, [-1, ttm.get_cellv(cell)])
	
	action = _actionGen(availableTiles, ttm)
	if !action.empty(): get_parent().tileRemovalHistory.append(action)
	
	for t in availableTiles:
		tile = ttm.get_cellv(t) != -1
		
		if tile:
			removeSnd.play()
			
			if brushSize < 5 && ttm.get_cellv(t) != -1:
				Main.plop(Vector2(8, 8) + t * ttm.cell_size)
				
			Main.level.funnyTileAnim(ttm, t, Vector2(256 * sin(mot.x), rand_range(-256, -512)))
			ttm.set_cellv(t, -1)
			
			get_parent().emit_signal("tile_removed", cell)
			
			if ttm in [Main.level, Main.level.tmBg]:
				Main.level.redrawShadows()
		else:
			if ttm != Main.level: return
			
			var n = Main.getNodeOnThisPos(t)
			
			if n:
				removeSnd.play()
				
				Main.plop(Vector2(8, 8) + t * ttm.cell_size)
					
				n.queue_free()
				get_parent().emit_signal("object_removed", cell)
	
func _actionGen(tileArr : Array, ttm : TileMap, exclude := [-1]) -> Dictionary:
	var act := {}
	var cnt := 0
		
	for t in tileArr:
		if ttm.get_cellv(t) in exclude:
			pass
		else:
			var entry := {
				"cell": t,
				"id": ttm.get_cellv(t),
				"ttm" : ttm,
				"flip_x" : ttm.is_cell_x_flipped(t.x, t.y),
				"flip_y" : ttm.is_cell_y_flipped(t.x, t.y),
				"transpose" : ttm.is_cell_transposed(t.x, t.y)
			}
			
			act[str(cnt)] = entry
			
			cnt += 1
			
	return act
	
func _singleInstanceCheck(inst):
	var exists := false
	
	if get_parent().target.singleInstance:
		exists = true if get_parent().level.get_node(inst.name) != null else false
	
	return exists
