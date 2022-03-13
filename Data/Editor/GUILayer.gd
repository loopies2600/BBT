extends CanvasLayer

onready var guiObjects := [$Sidebar, $EditorObjects, $MenuBar]

func _process(delta):
	if Main.editing:
		for o in guiObjects:
			o.show()
	else:
		for o in guiObjects:
			o.hide()
