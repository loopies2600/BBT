extends Camera2D

export (float, 0, 1) var damping = 0.9
export (int) var minZoom = 1
export (int) var maxZoom = 4
export (float) var zoomSpeed = 0.1

var canPlace := false
var panning := false
var target : Node2D
var intensity := Vector2()

func _process(_delta):
	drag_margin_h_enabled = !get_parent().editing
	drag_margin_v_enabled = !get_parent().editing
	
	if get_parent().editing:
		if canPlace:
			var shiftPan := Input.is_action_pressed("mouse_main") && Input.is_action_pressed("special")
			
			panning = Input.is_action_pressed("mouse_tertiary") || shiftPan
			
		offset = Vector2.ZERO
		intensity = Vector2.ZERO
	else:
		zoom = Vector2.ONE
	
		if target:
			global_position = target.global_position
		
		intensity *= damping
		
		if intensity.length() > 0.5:
			offset = Vector2(rand_range(-intensity.x, intensity.x), rand_range(-intensity.y, intensity.y))
		else:
			offset = Vector2()
	
func shake(xOff := 0, yOff := 0):
	intensity = Vector2(xOff, yOff)
	
func _input(event):
	if panning:
		if event is InputEventMouseMotion:
			global_position -= event.relative * zoom
		
	if get_parent().editing:
		if canPlace:
			if event is InputEventMouseButton:
				if event.is_pressed():
					var up = int(event.button_index == BUTTON_WHEEL_UP)
					var down = int(event.button_index == BUTTON_WHEEL_DOWN)
					var dir = down - up
					
					zoom.x = clamp(zoom.x + (zoomSpeed * dir), minZoom, maxZoom)
					zoom.y = clamp(zoom.y + (zoomSpeed * dir), minZoom, maxZoom)
