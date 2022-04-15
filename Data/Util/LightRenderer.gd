extends Node2D

const TEX := preload("res://Sprites/Particles/Light.png")

func _process(_delta):
	update()
	
	scale = Main.get_canvas_transform().get_scale()
	
func _draw():
	for l in get_tree().get_nodes_in_group("Light"):
		var scrPos : Vector2 = l.get_global_transform_with_canvas().origin / l.scale
		
		draw_set_transform(Vector2(), 0.0, l.scale)
		draw_texture(TEX, (scrPos / scale - (TEX.get_size() / 2) + Vector2(8, 8)))
