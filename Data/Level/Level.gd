extends TileMap

signal tile_anim_finished

const SHADOW := preload("res://Sprites/Tileset/Shadow.png")
const SHADOW_EXCLUDED := [2, 3, 4]

export (Vector2) var shadowOffset = Vector2.ZERO

var camBoundariesX := Vector2(0, 320)
var camBoundariesY := Vector2(0, 224)

func resetObjectState():
	for c in get_children():
		if c.has_method("resetState"):
			c.resetState()
	
func _ready():
	_flipOneWayCollisionShapes()
	
func _flipOneWayCollisionShapes():
	tile_set.tile_set_shape_transform(9, 0, Transform2D(deg2rad(90), Vector2(16, 0)))
	tile_set.tile_set_shape_transform(10, 0, Transform2D(deg2rad(270), Vector2(0, 16)))
	tile_set.tile_set_shape_transform(11, 0, Transform2D(deg2rad(180), Vector2(16, 16)))
	
func _process(_delta):
	update()
	
	if Global.editing:
		var cellsX := []
		var cellsY := []
		
		for c in get_used_cells():
			cellsX.append(c.x)
			cellsY.append(c.y)
			
		cellsX.sort()
		cellsY.sort()
		
		if cellsX:
			var preferred = cellsX[0] if cellsX[0] <= 0 else 0
			
			camBoundariesX = Vector2(preferred, cellsX[cellsX.size() - 1]) * 16
		if cellsY:
			var preferred = cellsY[0] if cellsY[0] <= 0 else 0
			
			camBoundariesY = Vector2(preferred, cellsY[cellsY.size() - 1]) * 16
		
func _draw():
	for c in get_used_cells():
		var pos = c * 16
		
		if get_cellv(c) in SHADOW_EXCLUDED: 
			pass
		else:
			draw_texture(SHADOW, pos + shadowOffset)
