extends Node2D

onready var _editorRotate = $Sprite
onready var ray := $HurtRay

func _physics_process(_delta):
	ray.rotation_degrees = 180 + _editorRotate.rotation_degrees
	
	if ray.is_colliding():
		var body = ray.get_collider()
		
		if body is Kinematos:
			body.kill()
