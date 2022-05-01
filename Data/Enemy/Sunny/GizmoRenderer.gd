extends Node2D

func _process(_delta):
	update()
	
func _draw():
	if !get_parent().drawGizmos: return
	
	draw_arc(get_parent().global_position, get_parent().distance, 0, TAU, 24, Color.tomato, 2)
