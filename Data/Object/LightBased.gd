extends CanvasItem

func _ready():
	set_as_toplevel(true)
	
func _process(_delta):
	if Main.editing:
		modulate.a = 1.0 if get_tree().get_nodes_in_group("Cursor")[0].targetTilemap.name == name else 0.5
	else:
		modulate.a = 1.0
