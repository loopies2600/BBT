extends Sprite

func _init():
	modulate = Color(0, 0, 0, 0.5)
	set_as_toplevel(true)
	
func _process(_delta):
	visible = Main.level.shadows
	
	region_enabled = get_parent().region_enabled
	region_rect = get_parent().region_rect
	texture = get_parent().texture
	
	rotation = get_parent().rotation
	scale.x = get_parent().get_parent().scale.x
	scale.y = owner.scale.y
	offset = get_parent().offset
	
	global_position = get_parent().global_position + Vector2(8, 8)
