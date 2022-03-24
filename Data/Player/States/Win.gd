extends State

export (float) var walkDuration = 2.0
export (float) var crouchDuration = 1.0

var phase := 0

func enter(_msg := {}):
	phase = 0
	
	yield(get_tree().create_timer(walkDuration), "timeout")
	phase += 1
	
	yield(get_tree().create_timer(crouchDuration), "timeout")
	phase += 1
	
	owner.recalcJumpValues(96)
	
func physics_update(_delta):
	match phase:
		0:
			owner.anim.play("Walk")
			owner.velocity.x = clamp(owner.velocity.x + owner.accel * owner.dir, -owner.maxSpd / 4, owner.maxSpd / 4) / owner.weight
		1:
			owner.anim.play("Crouch")
			owner.velocity *= 0.95
		2:
			owner.ganim.play("Jump")
			owner.anim.play("HappyDash")
			owner.velocity += Vector2(owner.jumpVel, 0).rotated(owner.upDirection.angle()).rotated(owner.gfx.rotation)
			phase += 1
		3:
			owner.velocity.x = clamp(owner.velocity.x + owner.accel * -owner.dir, -owner.maxSpd / 2, owner.maxSpd / 2) / owner.weight
			
			if owner.is_on_floor():
				phase += 1
		4:
			owner.bgTint.targetCol = Color(0.0, 0.0, 0.0, 0.5)
			owner.ganim.play("FromJump")
			phase += 1
		5:
			owner.anim.play("Dance")
			owner.velocity *= owner.damping
			
