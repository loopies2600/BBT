extends TileMap

signal tile_anim_finished

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
