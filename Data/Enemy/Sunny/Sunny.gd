extends Node2D

export (float) var distance = 64.0
export (int) var speed = -1
export (Vector2) var orbitDimension = Vector2(1, 1)
export (int) var initialAngle = 0

onready var center := position
onready var bolt := $Bolt
onready var ray := $DetectionRay
onready var spr := $Sprite

var angle := 0.0
var enabled := false

func _ready():
	angle = deg2rad(initialAngle)
	
func _physics_process(delta):
	position = (Vector2(1, 0).rotated(angle).normalized() * distance) * orbitDimension
	
	var toCenter : Vector2 = get_parent().global_position - global_position + Vector2(0, 8)
	
	bolt.points[1] = toCenter
	ray.cast_to = toCenter
	
	if !enabled: return
	
	angle += speed * delta
	angle = fmod(angle, TAU)
	
	if angle < 0:
		angle = TAU
	
	if ray.is_colliding():
		if ray.get_collider() is Player:
			ray.get_collider().kill()
		
	spr.rotation = PI / 2 + angle
