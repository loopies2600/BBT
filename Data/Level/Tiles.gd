extends TileMap

const TEST := preload("res://Sprites/Particles/DustBig.png")
const SHADOW_CASTERS := [0, 1]

export (int) var shadowOffset = 16
export (Color) var shadowColor = Color(0.0, 0.0, 0.0, 0.5)

func _ready():
	update()
	
func _draw():
	for c in get_used_cells():
		var pos = c * shadowOffset
		
		if get_cellv(c) in SHADOW_CASTERS:
			draw_rect(Rect2(pos + Vector2(shadowOffset / 2, shadowOffset / 2), Vector2(shadowOffset, shadowOffset)), shadowColor)
