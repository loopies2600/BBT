extends TileMap

signal tile_anim_finished

var camBoundariesX := Vector2(0, 320)
var camBoundariesY := Vector2(0, 224)

var darkMode := false

func resetObjectState():
	for c in get_children():
		if c.has_method("resetState"):
			c.resetState()
	
func initializeObjects():
	for c in get_children():
		if c.has_method("initialize"):
			c.initialize()
	
func _ready():
	_flipOneWayCollisionShapes()
	
func _flipOneWayCollisionShapes():
	tile_set.tile_set_shape_transform(9, 0, Transform2D(deg2rad(90), Vector2(16, 0)))
	tile_set.tile_set_shape_transform(10, 0, Transform2D(deg2rad(270), Vector2(0, 16)))
	tile_set.tile_set_shape_transform(11, 0, Transform2D(deg2rad(180), Vector2(16, 16)))
	
func _process(_delta):
	material.light_mode = 2 * int(darkMode)
