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
	
	p.recalcJumpValues(96)
	
func physics_update(_delta):
	match phase:
		0:
			p.anim.play("Walk")
			p.velocity.x = clamp(p.velocity.x + p.accel * p.dir, -p.maxSpd / 4, p.maxSpd / 4) / p.weight
		1:
			p.anim.play("Crouch")
			p.velocity *= 0.95
		2:
			p.ganim.play("Jump")
			p.anim.play("HappyDash")
			p.velocity += Vector2(p.jumpVel, 0).rotated(p.upDirection.angle()).rotated(p.gfx.rotation)
			phase += 1
		3:
			p.velocity.x = clamp(p.velocity.x + p.accel * -p.dir, -p.maxSpd / 2, p.maxSpd / 2) / p.weight
			
			if p.is_on_floor():
				phase += 1
		4:
			p.bgTint.targetCol = Color(0.0, 0.0, 0.0, 0.5)
			p.ganim.play("FromJump")
			phase += 1
		5:
			p.anim.play("Dance")
			p.velocity *= p.damping
			
