extends Node2D

func _process(_delta):
	global_position = -get_canvas_transform().origin
