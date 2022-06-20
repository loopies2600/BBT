extends CanvasLayer

onready var guiObjects := [$Sidebar, $EditorObjects, $MenuBar, $PlaceOptions]

func _process(delta):
	var alpha := float(Main.editing)
	
	for o in guiObjects:
		o.modulate.a = lerp(o.modulate.a, alpha, 20 * delta)
		
		if o.modulate.a < 0.1: o.hide() 
		else: o.show()
