extends Node2D

func _ready():
	update()
	
func _draw():
	draw_rect(Rect2(8, 8, 16, 16), Color(0, 0, 0, 0.5))
