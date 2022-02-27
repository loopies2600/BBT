extends Node2D

const TEX := preload("res://Sprites/Particles/Light.png")

func _process(_delta):
	update()
	
func _draw():
	for l in get_tree().get_nodes_in_group("Light"):
		draw_texture(TEX, l.get_global_transform_with_canvas().origin - (TEX.get_size() / 2) + Vector2(8, 8))
