extends Node2D

func _process(_delta):
	update()
	
func _draw():
	draw_rect(Rect2(0, 0, 16, 16), Color.white)
