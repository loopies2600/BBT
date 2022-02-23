extends CanvasLayer

onready var editorObjects := $EditorObjects
onready var menuBar := $MenuBar

func _process(delta):
	var ed : bool = Main.editing
	
	menuBar.rect_position.y = lerp(menuBar.rect_position.y, 0 if ed else -20, 16 * delta)
	editorObjects.rect_position.y = lerp(editorObjects.rect_position.y, 172 if ed else 224, 16 * delta)
