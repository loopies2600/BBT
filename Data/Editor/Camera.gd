extends Camera2D

export (float, 0, 1) var damping = 0.9
export (int) var minZoom = 1
export (int) var maxZoom = 2
export (float) var zoomSpeed = 0.1

var panning := false
var intensity := Vector2()

var target : Node2D

func _process(_delta):
	if get_parent().cursor.canPlace:
		panning = Input.is_action_pressed("mouse_tertiary")
		get_tree().get_root().get_node("Main").cursor.pointer = 3 * int(panning)
	
	if target:
		global_position = target.global_position
		
	intensity *= damping
	
	if intensity.length() > 0.5:
		offset = Vector2(rand_range(-intensity.x, intensity.x), rand_range(-intensity.y, intensity.y))
	else:
		offset = Vector2.ZERO
		
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

func shake(xOff := 0, yOff := 0):
	intensity = Vector2(xOff, yOff)
