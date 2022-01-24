extends State

func enter(msg := {}):
	if msg.has("isJump"):
		owner.velocity.y = owner.jumpHeight * owner.upDirection.y
		owner.anim.play("Jump")
	
func physics_update(delta):
	if sign(owner.velocity.y) == -sign(owner.upDirection.y):
		owner.anim.play("Fall")
		
	if owner.canInput:
		if owner.tools.getInputDirection():
			owner.dir = owner.tools.getInputDirection()
			owner.velocity.x = clamp(owner.velocity.x + owner.accel * owner.tools.getInputDirection(), -owner.maxSpd, owner.maxSpd)
		else:
			owner.velocity.x *= owner.airDamping
			
		if Input.is_action_just_pressed("attack"):
			emit_signal("finished", "dash")
	
	if owner.is_on_floor():
		emit_signal("finished", "idle")
	
