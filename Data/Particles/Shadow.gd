extends Sprite

func _init():
	modulate = Color(0, 0, 0, 0.5)
	set_as_toplevel(true)
	
func _process(_delta):
	region_enabled = get_parent().region_enabled
	region_rect = get_parent().region_rect
	texture = get_parent().texture
	
	rotation = get_parent().rotation
	scale = get_parent().scale
	
	global_position = get_parent().global_position + Vector2(8, 8)
