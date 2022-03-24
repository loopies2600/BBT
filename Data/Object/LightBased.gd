extends CanvasItem

func _ready():
	set_as_toplevel(true)
	
	yield(get_tree(), "idle_frame")
	var _unused = get_tree().get_nodes_in_group("Cursor")[0].connect("target_layer_changed", self, "_onLayerChange")
	
func _onLayerChange(lname):
	if Main.editing:
		modulate.a = lname == name
	else:
		modulate.a = 1.0
	
