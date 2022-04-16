extends Node2D

func _process(_delta):
	update()
	
	scale = Main.get_canvas_transform().get_scale()
	
func _draw():
	for c in get_tree().get_nodes_in_group("PureColor"):
		var scrPos : Vector2 = c.get_global_transform_with_canvas().origin / c.get_canvas_transform().get_scale() / c.scale
		
		draw_set_transform(Vector2(), 0.0, c.scale)
		draw_rect(Rect2(scrPos, Vector2(16, 16) * c.scale), c.modulate)
