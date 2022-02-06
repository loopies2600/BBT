extends Node2D

const SHADOW := preload("res://Sprites/Tileset/Shadow.png")
const SHADOW_EXCLUDED := [2, 3, 4]

export (Vector2) var shadowOffset = Vector2(8, 8)

func _process(_delta):
	update()
	
func _draw():
	for c in Global.level.get_used_cells():
		var pos = c * 16
		
		if Global.level.get_cellv(c) in SHADOW_EXCLUDED: 
			pass
		else:
			var tex = Global.level.tile_set.tile_get_texture(Global.level.get_cellv(c))
			var region = Global.level.tile_set.tile_get_region(Global.level.get_cellv(c))
			
			draw_texture_rect_region(tex, Rect2(pos + shadowOffset, region.size), region)
