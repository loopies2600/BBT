extends KinematicBody2D

export (float) var distance = 64.0
export (int) var speed = -1
export (Vector2) var orbitDimension = Vector2(1, 1)
export (int) var initialAngle = 0

onready var center = position

var angle := 0.0
var enabled := false

func _ready():
	angle = deg2rad(initialAngle)
	
func _physics_process(delta):
	position = (Vector2(1, 0).rotated(angle).normalized() * distance) * orbitDimension
	
	if !enabled: return
	
	angle += speed * delta
	angle = fmod(angle, TAU)
	
	if angle < 0:
		angle = TAU
	
