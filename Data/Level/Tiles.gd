extends TileMap

const SHADOW := preload("res://Sprites/Tileset/Shadow.png")
const SHADOW_CASTERS := [0, 1, 5, 6, 7, 8]

export (Vector2) var camBoundaries = Vector2(320, 224)
export (Vector2) var shadowOffset = Vector2.ZERO

func _ready():
	update()
	
func _draw():
	for c in get_used_cells():
		var pos = c * 16
		
		if get_cellv(c) in SHADOW_CASTERS:
			draw_texture(SHADOW, pos + shadowOffset)
