extends Control

onready var desc = $CenterContainer/Description

var exit := false

func _ready():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _process(delta):
	rect_position = lerp(rect_position, Vector2(0, -224) if exit else Vector2.ZERO, 16 * delta)
	
func _input(event):
	if event.is_pressed():
		exit = true
		
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		
		get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
		queue_free()
