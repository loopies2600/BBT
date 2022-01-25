extends Area2D

export (int) var shadowOffset = 8
export (Color) var shadowColor = Color(0.0, 0.0, 0.0, 0.5)

func _ready():
	update()
	
func _draw():
	draw_rect(Rect2(Vector2(shadowOffset, shadowOffset), Vector2(64, 64)), shadowColor)
