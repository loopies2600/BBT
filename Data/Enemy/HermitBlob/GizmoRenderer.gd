extends Node2D

func _ready():
	set_as_toplevel(true)
	
func _process(_delta):
	update()
	
func _draw():
	if !Main.editing: return
	if !get_parent().drawGizmos: return
	
	draw_line(get_parent().global_position + Vector2(8, 0).rotated(get_parent().rotation), get_parent().global_position + Vector2(8, -get_parent().jumpHeight).rotated(get_parent().rotation), Color.red, 2)
	draw_line(get_parent().global_position + Vector2(8, 0).rotated(get_parent().rotation), get_parent().global_position + Vector2(8, -get_parent().ray.shape.length).rotated(get_parent().rotation), Color.green, 2)
