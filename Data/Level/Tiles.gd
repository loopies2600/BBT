extends TileMap

const TEST := preload("res://Sprites/Particles/DustBig.png")
const SHADOW_CASTERS := [0, 1, 5, 6, 7, 8]

export (int) var shadowOffset = 16
export (Color) var shadowColor = Color(0.0, 0.0, 0.0, 0.5)

var shadowTextures := []

func _ready():
	update()
	
func _draw():
	for c in get_used_cells():
		var pos = c * shadowOffset
		
		if get_cellv(c) in SHADOW_CASTERS:
			draw_rect(Rect2(pos + Vector2(shadowOffset / 2, shadowOffset / 2), Vector2(shadowOffset, shadowOffset)), shadowColor)
