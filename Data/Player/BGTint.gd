extends Node2D

export (Color) var targetCol := Color(1.0, 1.0, 1.0, 0.0)

var col := Color(0.0, 0.0, 0.0, 0.0)

func _process(delta):
	col = lerp(col, targetCol, 16 * delta)
	
	update()
	
func _draw():
	var ctrans := get_global_transform_with_canvas()
	
	draw_rect(Rect2(-ctrans.origin / ctrans.get_scale(), Vector2(416, 240) / ctrans.get_scale()), col, true)
