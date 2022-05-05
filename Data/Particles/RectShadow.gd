extends Node2D

func _process(_delta):
	update()
	
func _draw():
	if !Main.level.shadows: return
	
	draw_rect(Rect2(8, 8, 16, 16), Color(0, 0, 0, 0.5))
