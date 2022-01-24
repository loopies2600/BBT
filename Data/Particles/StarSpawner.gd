extends Sprite

export (float) var distance = 48
export (int) var speed = -3
export (Vector2) var orbitDimension = Vector2(0.5, 1)
export (int) var initialAngle = 0
export (float) var spawnRate = 0.075

var angle := 0.0
onready var center = position

func _ready():
	angle = deg2rad(initialAngle)
	
	_starLoop()
	
func _starLoop():
	var star = load("res://Data/Particles/Star.tscn").instance()
	
	get_tree().get_root().call_deferred("add_child", star)
	star.global_position = global_position
	star.modulate = get_parent().get_parent().modulate
	
	yield(get_tree().create_timer(spawnRate), "timeout")
	_starLoop()
	 
func _physics_process(delta):
	if rad2deg(angle) > 250 || rad2deg(angle) < 90:
		z_index = -1
	else:
		z_index = 5
		
	angle += speed * delta
	angle = fmod(angle, TAU)
	
	if angle < 0:
		angle = TAU
	
	position = center + Vector2(sin(angle) * orbitDimension.x, cos(angle) * orbitDimension.y) * distance

static func remapToRange(value : float, iStart : float, iStop : float, oStart : float, oStop : float) -> float:
	return oStart + (oStop - oStart) * ((value - iStart) / (iStop - iStart))
