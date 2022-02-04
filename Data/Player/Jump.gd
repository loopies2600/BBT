extends State

var jumping := false
var cancelled := false

func enter(msg := {}):
	if !owner.god:
		if msg.has("jumpHeight"):
			jumping = true
			owner.velocity = Vector2(msg["jumpHeight"], 0).rotated(owner.upDirection.angle())
		
	if msg.has("antiCancel"):
		cancelled = true
	
func physics_update(_delta):
	if sign(owner.velocity.y) == -sign(owner.upDirection.y):
		owner.anim.play("Fall")
	else:
		if jumping:
			owner.anim.play("Jump")
			
	if owner.canInput:
		if owner.tools.getInputDirection():
			owner.dir = owner.tools.getInputDirection()
			owner.velocity.x = clamp(owner.velocity.x + owner.accel * owner.tools.getInputDirection(), -owner.maxSpd, owner.maxSpd)
		else:
			owner.velocity.x *= owner.airDamping
			
		if Input.is_action_just_pressed("attack"):
			emit_signal("finished", "attack")
			
		if owner.god:
			if Input.is_action_pressed("jump"):
				owner.velocity.y = owner.jumpHeight * owner.upDirection.y
			
		if jumping && !cancelled:
			if Input.is_action_just_released("jump"):
				owner.velocity.y *= 0.5
				cancelled = true
	
	if owner.is_on_floor():
		emit_signal("finished", "idle")
	
func exit():
	jumping = false
	cancelled = false
