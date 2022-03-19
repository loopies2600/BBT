extends Control

onready var desc = $CenterContainer/Description
onready var title := $CenterContainer2/Title

var exit := false

func _ready():
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _process(delta):
	modulate.a = lerp(modulate.a, 1.0 if !exit else 0.0, 20 * delta)
	
func _input(event):
	if !exit:
		if event.is_pressed():
			exit = true
			
			yield(get_tree().create_timer(0.15), "timeout")
			
			get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
			queue_free()
