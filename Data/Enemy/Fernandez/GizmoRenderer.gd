extends Node2D

func _process(_delta):
	update()
	
func _draw():
	if !Main.editing: return
	if !get_parent().drawGizmos: return
	
	draw_circle(get_parent().area.position, get_parent().area.shape.radius, Color.deeppink)
