extends Camera2D

export (float, 0, 1) var damping = 0.9
export (float) var minZoom = 0.5
export (int) var maxZoom = 4
export (float) var zoomSpeed = 0.1

var canPlace := false
var panning := false
var target : Node2D
var intensity := Vector2()
var lock := false
var baseZoom := Vector2.ONE

func _process(delta):
	if lock: return
	
	if get_parent().editing:
		# KEYBOARD CONTROLS
		var transDir := Vector2(int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")), int(Input.is_action_pressed("look_down")) - int(Input.is_action_pressed("look_up")))
		
		if transDir:
			global_position += transDir.normalized() * 8
		
		var scaleDir := int(Input.is_action_pressed("jump")) - int(Input.is_action_pressed("attack"))
		
		baseZoom.x = clamp(baseZoom.x + (zoomSpeed / 2 * scaleDir), minZoom, maxZoom)
		baseZoom.y = clamp(baseZoom.y + (zoomSpeed / 2 * scaleDir), minZoom, maxZoom)
	
		zoom = lerp(zoom, baseZoom, 8 * delta)
		
		if canPlace:
			var shiftPan := Input.is_action_pressed("mouse_main") && Input.is_action_pressed("special")
			
			panning = Input.is_action_pressed("mouse_tertiary") || shiftPan
			
		offset = Vector2.ZERO
		intensity = Vector2.ZERO
	else:
		zoom = lerp(zoom, Vector2.ONE, 8 * delta)
	
		if target:
			var camOffset = Vector2()
			
			if target.get("camOffset"):
				camOffset = target.camOffset
			
			global_position = target.global_position + camOffset
		
		intensity *= damping
		
		if intensity.length() > 0.5:
			offset = Vector2(rand_range(-intensity.x, intensity.x), rand_range(-intensity.y, intensity.y))
		else:
			offset = Vector2()
	
func shake(xOff := 0, yOff := 0):
	intensity = Vector2(xOff, yOff)
	
func _input(event):
	if lock: return
	
	if panning:
		if event is InputEventMouseMotion:
			global_position -= event.relative * baseZoom
		
	if get_parent().editing:
		if canPlace:
			if event is InputEventMouseButton:
				if event.is_pressed():
					var up = int(event.button_index == BUTTON_WHEEL_UP)
					var down = int(event.button_index == BUTTON_WHEEL_DOWN)
					var dir = down - up
					
					baseZoom.x = clamp(baseZoom.x + (zoomSpeed * dir), minZoom, maxZoom)
					baseZoom.y = clamp(baseZoom.y + (zoomSpeed * dir), minZoom, maxZoom)
