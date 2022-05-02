extends Node2D

func _ready():
	set_as_toplevel(true)
	
func _process(_delta):
	update()
	
func _draw():
	if !get_parent().drawGizmos: return
	
	draw_arc(get_parent().global_position + Vector2(8, 8), get_parent().distance, 0, TAU, 24, Color.tomato, 2)
