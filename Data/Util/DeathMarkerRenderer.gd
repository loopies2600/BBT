extends Node2D

const MARKER := preload("res://Sprites/Player/DeathMarker.png")

var marks := []

func _process(_delta):
	update()
	
func _draw():
	for m in marks:
		draw_texture(MARKER, m + Main.level.get_canvas_transform().origin - MARKER.get_size() / 2)
