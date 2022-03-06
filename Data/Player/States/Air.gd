extends State

var jumping := false
var cancelled := false

func enter(msg := {}):
	if !owner.god:
		if msg.has("jumpHeight"):
			owner.sounds[0].pitch_scale = rand_range(0.75, 1.25)
			owner.sounds[0].play()
			
			if int(msg["jumpHeight"]) != 0:
				owner.recalcJumpValues(msg["jumpHeight"])
			
			jumping = true
			
			if msg.has("antiCancel"):
				owner.velocity.y = 0.0
				
			owner.velocity += Vector2(owner.jumpVel, 0).rotated(owner.upDirection.angle())
		else:
			owner.recalcJumpValues(owner.jumpHeight)
			
	if msg.has("antiCancel"):
		cancelled = true
	
	if get_parent().previous_state == "slide":
		owner._doDust = true
		
func physics_update(_delta):
	if sign(owner.velocity.y) == -sign(owner.upDirection.y):
		if get_parent().previous_state != "slide":
			owner.anim.play("Fall")
	else:
		if jumping:
			var anim := "Jump"
			
			match get_parent().previous_state:
				"slide":
					anim = "Dash"
		
			owner.anim.play(anim)
			
	if owner.canInput:
		if owner.iDir:
			owner.dir = owner.iDir
			owner.velocity.x = clamp(owner.velocity.x + owner.accel * owner.iDir, -owner.maxSpd, owner.maxSpd)
		else:
			owner.velocity.x *= owner.airDamping
			
		if Input.is_action_just_pressed("attack"):
			emit_signal("finished", "dash")
			
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
