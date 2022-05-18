extends Spatial

onready var frontFace := $Front

func _ready():
	$Camera.set_as_toplevel(true)
	
func _process(delta):
	if owner.selected:
		rotation_degrees.y += 256 * delta
	else:
		rotation.y = lerp_angle(rotation.y, 0, 8 * delta)
