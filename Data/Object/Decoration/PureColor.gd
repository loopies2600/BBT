extends Node2D

func _ready():
	update()
	
func _draw():
	draw_rect(Rect2(0, 0, 16, 16), Color.white)
