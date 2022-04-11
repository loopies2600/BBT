extends State

const EXPLOSION := preload("res://Data/Particles/Explosion/Explosion.tscn")

var rcVel := Vector2()
var rcRot := 0.0

onready var spd : float = owner.velocity.x

func enter(_msg := {}):
	owner.anim.play("Rocket")
	owner.velocity = Vector2.ZERO
	owner.doGravity = false
	
	owner._doDust = true
	rcRot = 0.0
	
	spd = owner.velocity.x
	spd += owner.rocketSpeed
	owner.dir = 1
	
func physics_update(delta):
	spd += owner.rocketAccel * delta
	
	var dir : int = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	rcRot += (owner.rocketSteering * dir) * delta
	
	owner.rotation = lerp_angle(owner.rotation, rcRot, 12 * delta)
	
	owner.velocity = Vector2(spd, 0).rotated(owner.rotation)
	owner.dustOffset = Vector2(-24, 12).rotated(owner.rotation)
	
	if owner.get_slide_count():
		Main.level.purgeCircle((owner.global_position / 16).round(), 4)
		owner.rotation = 0.0
		
		var explosion := EXPLOSION.instance()
		explosion.global_position = owner.global_position
		Main.level.add_child(explosion)
		
		owner.velocity = Vector2()
		owner.kill()
		
func exit():
	owner.dustOffset = Vector2()
	
	rcVel = Vector2()
	spd = 0.0
	
	owner.doGravity = true
	owner.rotation = 0.0
	owner._doDust = false
