extends TileMap

signal tile_anim_finished

const SHADOW := preload("res://Sprites/Tileset/Shadow.png")
const SHADOW_EXCLUDED := [2, 3, 4]

export (Vector2) var camBoundaries = Vector2(320, 224)
export (Vector2) var shadowOffset = Vector2.ZERO

export (float) var copySpeed := 0.05
export (int) var copyPerIteration := 20

var _layoutPosCopy := []
var _tileIDCopy := []

var firstRun := true

func _ready():
	_flipOneWayCollisionShapes()
	
	if firstRun: 
		_copyLayout()
		
		return
	
	emit_signal("tile_anim_finished")
	
func _flipOneWayCollisionShapes():
	tile_set.tile_set_shape_transform(9, 0, Transform2D(deg2rad(90), Vector2(16, 0)))
	tile_set.tile_set_shape_transform(10, 0, Transform2D(deg2rad(270), Vector2(0, 16)))
	tile_set.tile_set_shape_transform(11, 0, Transform2D(deg2rad(180), Vector2(16, 16)))
	
func _copyLayout():
	yield(get_tree(), "idle_frame")
	var offset := Vector2(get_canvas_transform().origin.round() / 16).round()
	
	_layoutPosCopy = get_used_cells()
	
	var iteration := 0
	
	for pos in _layoutPosCopy:
		
		if pos.x > 19 - offset.x || pos.x < offset.x:
			_layoutPosCopy.remove(iteration)
			print(pos.x)
			
		if pos.y > 13 - offset.y || pos.y < offset.y:
			_layoutPosCopy.remove(iteration)
		
		iteration += 1
			
	for c in _layoutPosCopy:
		_tileIDCopy.append(get_cell(c[0], c[1]))
		
	for tX in range(20 - offset.x):
		for tY in range(14 - offset.y):
			set_cell(tX, tY, -1)
	
	_copyCell(0, offset)
	
func _copyCell(idx := 0, mapOffset := Vector2()):
	for i in range(copyPerIteration):
		var posX = _layoutPosCopy[idx][0]
		var posY = _layoutPosCopy[idx][1]
		
		set_cell(posX, posY, _tileIDCopy[idx])
		
		var xInTrans := bool(posX > abs(mapOffset.x) - 1)
		var xNotOffscreen := bool(posX < 20 - mapOffset.x)
		var yInTrans := bool(posY < abs(14) - mapOffset.y)
		var yNotOffscreen := bool(posY > mapOffset.y - 1)
		
		if xInTrans && xNotOffscreen && yInTrans && yNotOffscreen:
			Global.plop(Vector2(posX, posY) * 16 + Vector2(8, 8))
		
		if idx < _layoutPosCopy.size() - 1:
			idx += 1
		
	if idx < _layoutPosCopy.size() - 1:
		yield(get_tree().create_timer(copySpeed), "timeout")
		
		_copyCell(idx, mapOffset)
	else:
		emit_signal("tile_anim_finished")
	
func _process(_delta):
	update()
	
func _draw():
	for c in get_used_cells():
		var pos = c * 16
		
		if get_cellv(c) in SHADOW_EXCLUDED: 
			pass
		else:
			draw_texture(SHADOW, pos + shadowOffset)
