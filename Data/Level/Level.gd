extends TileMap

signal tile_anim_finished

const SHADOW := preload("res://Sprites/Tileset/Shadow.png")
const SHADOW_CASTERS := [0, 1, 5, 6, 7, 8]

export (Vector2) var camBoundaries = Vector2(320, 224)
export (Vector2) var shadowOffset = Vector2.ZERO

export (float) var copySpeed := 0.05
export (int) var copyPerIteration := 20

var _layoutPosCopy := []
var _tileIDCopy := []

var firstRun := true

func _ready():
	if firstRun: 
		_copyLayout()
		return
	
	emit_signal("tile_anim_finished")
	
func _copyLayout():
	_layoutPosCopy = get_used_cells()
	
	var iteration := 0
	
	for pos in _layoutPosCopy:
		if pos.x > 19:
			_layoutPosCopy.remove(iteration)
		
		if pos.y > 13:
			_layoutPosCopy.remove(iteration)
		
		iteration += 1
			
	for c in _layoutPosCopy:
		_tileIDCopy.append(get_cell(c[0], c[1]))
		
	for tX in range(20):
		for tY in range(14):
			set_cell(tX, tY, -1)
	
	_copyCell(0)
	
func _copyCell(idx := 0):
	for i in range(copyPerIteration):
		var posX = _layoutPosCopy[idx][0]
		var posY = _layoutPosCopy[idx][1]
		
		set_cell(posX, posY, _tileIDCopy[idx])
		
		if posX < 20 && posY < 14:
			Global.plop(Vector2(posX, posY) * 16 + Vector2(8, 8))
		
		if idx < _layoutPosCopy.size() - 1:
			idx += 1
		
	if idx < _layoutPosCopy.size() - 1:
		yield(get_tree().create_timer(copySpeed), "timeout")
		
		_copyCell(idx)
	else:
		emit_signal("tile_anim_finished")
		
	update()
	
func _draw():
	for c in get_used_cells():
		var pos = c * 16
		
		if get_cellv(c) in SHADOW_CASTERS:
			draw_texture(SHADOW, pos + shadowOffset)
