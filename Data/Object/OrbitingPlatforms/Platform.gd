extends KinematicBody2D

export (float) var distance = 64.0
export (int) var speed = -1
export (Vector2) var orbitDimension = Vector2(1, 1)
export (int) var initialAngle = 0

var angle := 0.0
onready var center = position

func _ready():
	angle = deg2rad(initialAngle)
	
func _physics_process(delta):
	angle += speed * delta
	angle = fmod(angle, TAU)
	
	if angle < 0:
		angle = TAU
	
	position = center + Vector2(sin(angle) * orbitDimension.x, cos(angle) * orbitDimension.y) * distance

