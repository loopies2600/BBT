extends Node2D

func _ready():
	set_as_toplevel(true)
	
func _process(_delta):
	update()
	
func _draw():
	if !get_parent().drawGizmos: return
	if !Main.editing: return
	
	draw_circle(get_parent().global_position + Vector2(8, 0), get_parent().detectionRadius, Color.deeppink)
	draw_arc(get_parent().global_position + Vector2(8, 8), get_parent().tileSearchRadius * 16, 0, TAU, 24, Color.tomato, 2)

