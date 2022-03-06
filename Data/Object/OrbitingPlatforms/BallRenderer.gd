extends Node2D

const BALL := preload("res://Sprites/Object/Ball.tres")

func _ready():
	set_as_toplevel(true)
	
func _process(_delta):
	update()
	
func _draw():
	for c in get_parent().get_children():
		var pB : int = ceil(c.global_position.distance_to(get_parent().global_position)) / 16
		
		for i in range(pB):
			if c.name != "BallRenderer":
				var w : float = (1.0 / pB) * i
				
				draw_texture(BALL, lerp(get_parent().global_position, c.global_position, w))
