extends Camera2D

export (int) var minZoom = 1
export (int) var maxZoom = 2
export (float) var zoomSpeed = 0.1

var panning := false

func _process(_delta):
	if get_parent().cursor.canPlace:
		panning = Input.is_action_pressed("mouse_tertiary")
		Global.cursor.pointer = 3 * int(panning)
	
func _input(event):
	if panning:
		if event is InputEventMouseMotion:
			global_position -= event.relative * zoom
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			var up = int(event.button_index == BUTTON_WHEEL_UP)
			var down = int(event.button_index == BUTTON_WHEEL_DOWN)
			var dir = down - up
			
			zoom.x = clamp(zoom.x + (zoomSpeed * dir), minZoom, maxZoom)
			zoom.y = clamp(zoom.y + (zoomSpeed * dir), minZoom, maxZoom)
