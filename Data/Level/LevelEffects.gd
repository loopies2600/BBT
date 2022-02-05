extends Node2D

func _process(_delta):
	update()
	
func _draw():
	if get_parent().darkMode:
		draw_rect(Rect2(-get_canvas_transform().origin, Vector2(320, 224)), Color.black)
	
