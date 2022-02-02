extends Control

onready var desc = $CenterContainer/Description

func _ready():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _input(event):
	if event.is_pressed():
		hide()
		
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		
		get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
		queue_free()
