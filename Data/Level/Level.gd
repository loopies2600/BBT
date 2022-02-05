extends TileMap

signal tile_anim_finished

const SHADOW := preload("res://Sprites/Tileset/Shadow.png")
const SHADOW_EXCLUDED := [2, 3, 4]

export (Vector2) var shadowOffset = Vector2.ZERO

var camBoundariesX := Vector2(0, 320)
var camBoundariesY := Vector2(0, 224)

var darkMode := false

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
	
	material.light_mode = 2 * int(darkMode)
	
func generateCameraBoundaries():
	var rect := get_used_rect()
	
	var firstCellX = rect.position.x
	var lastCellX = rect.size.x + firstCellX
	
	var firstCellY = rect.position.y
	var lastCellY = rect.size.y + firstCellY
	
	var preferredX = firstCellX if firstCellX < 0 else 0
	var preferredY = lastCellX if lastCellX > 20 else 20
	
	camBoundariesX = Vector2(preferredX, preferredY) * 16
	
	preferredX = firstCellY if firstCellY < 0 else 0
	preferredY = lastCellY if lastCellY > 14 else 14
	
	camBoundariesY = Vector2(preferredX, preferredY) * 16
		
func _draw():
	for c in get_used_cells():
		var pos = c * 16
		
		if get_cellv(c) in SHADOW_EXCLUDED: 
			pass
		else:
			draw_texture(SHADOW, pos + shadowOffset)
