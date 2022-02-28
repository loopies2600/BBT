extends TileMap

const INDESTRUCTIBLE := [23, 24]

signal tile_anim_finished

var camBoundariesX := Vector2(0, 320)
var camBoundariesY := Vector2(0, 240)

var darkMode := false

var _cellPosCopy := []
var _cellIDCopy := []

var _flipXCopy := []
var _flipYCopy := []
var _transposeCopy := []

func resetObjectState():
	for c in get_children():
		if c.has_method("resetState"):
			c.resetState()
	
func initializeObjects():
	for c in get_children():
		if c.has_method("initialize"):
			c.initialize()
	
func copyMap():
	_cellPosCopy.clear()
	_cellIDCopy.clear()
	_flipXCopy.clear()
	_flipYCopy.clear()
	_transposeCopy.clear()
	
	for c in get_used_cells():
		_cellPosCopy.append(c)
		_cellIDCopy.append(get_cellv(c))
		
		_flipXCopy.append(is_cell_x_flipped(c.x, c.y))
		_flipYCopy.append(is_cell_y_flipped(c.x, c.y))
		_transposeCopy.append(is_cell_transposed(c.x, c.y))
	
func restoreMap():
	for c in get_used_cells():
		set_cellv(c, -1)
		
	for c in range(_cellPosCopy.size()):
		set_cellv(_cellPosCopy[c], _cellIDCopy[c], _flipXCopy[c], _flipYCopy[c], _transposeCopy[c])
		
func _ready():
	_flipOneWayCollisionShapes()
	
func purgeCircle(pos, radius, with := -1, target := self):
	for y in range(-radius - 1, radius + 1):
		for x in range(-radius - 1, radius + 1):
			if (x * x) + (y * y) <= (radius * radius):
				if target.get_cellv(pos + Vector2(x, y)) in INDESTRUCTIBLE:
					pass
				else:
					target.set_cellv(pos + Vector2(x, y), with)
				
func _flipOneWayCollisionShapes():
	tile_set.tile_set_shape_transform(9, 0, Transform2D(deg2rad(90), Vector2(16, 0)))
	tile_set.tile_set_shape_transform(10, 0, Transform2D(deg2rad(270), Vector2(0, 16)))
	tile_set.tile_set_shape_transform(11, 0, Transform2D(deg2rad(180), Vector2(16, 16)))
	
func _process(delta):
	material.light_mode = 2 * int(darkMode)
