extends Node2D

onready var sY := global_position.y

var _time = 0.0

func _process(delta):
	global_position.y = sY + sin(_time * 2) * 4
	
	_time += delta
