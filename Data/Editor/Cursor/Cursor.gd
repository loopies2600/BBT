extends Node2D

# warning-ignore:unused_signal
signal tile_placed(pos)
# warning-ignore:unused_signal
signal tile_removed(pos)
# warning-ignore:unused_signal
signal object_placed(pos)
# warning-ignore:unused_signal
signal object_removed(pos)
signal mode_changed(idx)
signal target_layer_changed(lname)

onready var level : TileMap = Main.level
onready var targetTilemap := level setget _setTarget
onready var modes := [$PlaceMode, $MoveMode, $ConfigMode]

var mode = 0 setget _setMode

var canPlace := true

var configurator
var target
var texture : Texture

var alreadyPressed := false
var cellPos := Vector2()

var _tileEntryTemplate := {
	"cell": Vector2(),
	"id": 2,
	"ttm" : Main.level,
	"flip_x" : false,
	"flip_y" : false,
	"transpose" : false
}

var tileRemovalHistory := []
var tilePlacingHistory := []

func _plcTile():
	if tileRemovalHistory.empty(): return
	
	var action = _toyWithDict(tileRemovalHistory)
	
	tilePlacingHistory.append(action)
	
	Main.level.redrawShadows()
	
func _delTile():
	if tilePlacingHistory.empty(): return
	
	var action = _toyWithDict(tilePlacingHistory, false)
	
	tileRemovalHistory.append(action)
	
	Main.level.redrawShadows()
	
func _toyWithDict(arr : Array, placeTile := true):
	var action = arr.pop_back()
	
	for entry in action:
		entry = action[entry]
		
		if placeTile:
			entry.ttm.set_cellv(entry.cell, entry.id, entry.flip_x, entry.flip_y, entry.transpose)
		else:
			entry.ttm.set_cellv(entry.cell, -1)
		
	return action
		
func _setMode(idx : int):
	if mode == idx: return
	
	mode = idx
	emit_signal("mode_changed", mode)
	
func _setTarget(t : TileMap):
	if targetTilemap == t: return
	
	targetTilemap = t
	emit_signal("target_layer_changed", targetTilemap.name)
	
func _ready():
	var _unused = connect("object_placed", level, "_onObjectPlace")
	_unused = connect("object_removed", level, "_onObjectRemoval")
	
func _process(_delta):
	Main.cam.canPlace = canPlace
	
	visible = Main.editing
	
	var result : Vector2 = (_frickinPositionFormula() / level.cell_size).round() * level.cell_size
	
	if !Main.editing:
		texture = null
		return
	
	if canPlace:
		global_position = result
		cellPos = ((global_position / level.cell_size).round() / level.scale).round()
	
	modes[mode].update()
	update()
	
func _draw():
	if !texture: return
	
	var radius : int = modes[0].brushSize
	
	for y in range(-radius, radius):
		for x in range(-radius, radius):
			if (x * x) + (y * y) < (radius * radius):
				var mod := Color.white
				
				if !target.isTile: mod = Color(modes[0].basePlaceOptions["modulate:r"], modes[0].basePlaceOptions["modulate:g"], modes[0].basePlaceOptions["modulate:b"], 1.0)
				else:
					var fx : bool = modes[0].basePlaceOptions["flip_x"]
					var fy : bool = modes[0].basePlaceOptions["flip_y"]
					
					var pos = Vector2(16 if fx else 0, 16 if fy else 0)
					
					draw_set_transform(pos, 0.0, Vector2(-1 if fx else 1, -1 if fy else 1))
					
				draw_texture(texture, Vector2(targetTilemap.cell_size.x * x, targetTilemap.cell_size.x * y), mod)

func _frickinPositionFormula() -> Vector2:
	var mousePos := get_global_mouse_position()
	var cursorOffset := Vector2(8, 8)
	
	var result : Vector2 = (((mousePos - cursorOffset) / level.cell_size).round() / level.scale).round() * level.cell_size
	
	return result
	
func configuratorCheck() -> bool:
	if configurator:
		configurator.close()
		return true
		
	return false
	
func _input(event):
	if !Main.editing:
		return
		
	if Input.is_action_pressed("mouse_main"):
		if Input.is_action_pressed("special"): return
		
		modes[mode].mainClick(event)
	elif Input.is_action_pressed("mouse_secondary"):
		modes[mode].subClick(event)
	
	if event.is_action("undo") && !event.is_echo() && event.is_pressed():
		_delTile()
	if event.is_action("redo") && !event.is_echo() && event.is_pressed():
		_plcTile()
