extends Spatial

onready var chara = $MonitorDisplay/Character
onready var bg = $MonitorDisplay/BG
onready var label = $MonitorDisplay/Label
onready var anim = $MonitorDisplay/Animator

var rotSpeed := 2175.0
var _time := 0.0

func _ready():
	$Camera.set_as_toplevel(true)
	
func _process(delta):
	$DirectionalLight.rotation.x += 8 * delta
	
	bg.flip_v = !bg.flip_v
	
	if rotSpeed < 1768:
		rotation.x = lerp_angle(rotation.x, 0.2, 8 * delta)
		
		rotation_degrees.y = sin(_time * 3) * 16
		rotation_degrees.z = sin(_time * 3) * 16
		_time += delta
	else:
		rotation_degrees.x -= rotSpeed * delta
	
	rotSpeed *= 0.98
