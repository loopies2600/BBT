extends Camera2D

export (float, 0, 1) var damping = 0.9

var intensity := Vector2()

func _process(_delta):
	intensity *= damping
	
	if intensity.length() > 0.5:
		offset = Vector2(rand_range(-intensity.x, intensity.x), rand_range(-intensity.y, intensity.y))
	else:
		offset = Vector2()
		
func shake(xOff := 0, yOff := 0):
	intensity = Vector2(xOff, yOff)
