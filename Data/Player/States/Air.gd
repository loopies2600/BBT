extends State

var jumping := false
var cancelled := false
var ignoreAnim := false

func enter(msg := {}):
	ignoreAnim = msg.has("ignoreAnim")
	
	if !owner.god:
		if msg.has("jumpHeight"):
			owner.sounds[0].pitch_scale = rand_range(0.75, 1.25)
			owner.sounds[0].play()
			
			if int(msg["jumpHeight"]) != 0:
				owner.recalcJumpValues(msg["jumpHeight"])
			
			jumping = true
			
			if msg.has("antiCancel"):
				owner.velocity.y = 0.0
				
			owner.velocity += Vector2(owner.jumpVel, 0).rotated(owner.upDirection.angle()).rotated(owner.gfx.rotation)
		else:
			owner.recalcJumpValues(owner.jumpHeight)
			
	if msg.has("antiCancel"):
		cancelled = true
	
	if get_parent().previous_state == "slide" || get_parent().previous_state == "walled":
		owner._doDust = true
		
func physics_update(_delta):
	if !ignoreAnim:
		if sign(owner.velocity.y) == -sign(owner.upDirection.y):
			var anim := "Fall"
			
			match get_parent().previous_state:
				"slide":
					anim = "Dash"
				"walled":
					anim = "WallFall"
				
			owner.anim.play(anim)
		else:
			if jumping:
				var anim := "Jump"
				owner.ganim.play("Jump")
				
				match get_parent().previous_state:
					"slide":
						anim = "Dash"
					"walled":
						anim = "WallJump"
			
				owner.anim.play(anim)
				
	if owner.canInput:
		if owner.iDir:
			var valid := true
			
			if get_parent().previous_state == "slide":
				valid = owner.dir != owner.iDir
			
			if valid:
				owner.dir = owner.iDir
				owner.velocity.x = clamp(owner.velocity.x + owner.accel * owner.iDir, -owner.maxSpd, owner.maxSpd)
		else:
			owner.velocity.x *= owner.airDamping
			
		if owner.canDash:
			if Input.is_action_just_pressed("attack"):
				emit_signal("finished", "dash")
			
		if owner.god:
			if Input.is_action_pressed("jump"):
				owner.velocity.y = owner.jumpHeight * owner.upDirection.y
		
		if owner.closeToWall() && Input.is_action_just_pressed("jump") && owner.canWallJump:
			emit_signal("finished", "walled")
		
		if jumping && !cancelled:
			if Input.is_action_just_released("jump"):
				owner.velocity.y *= 0.5
				cancelled = true
	
	if owner.is_on_floor():
		owner.ganim.play("FromJump")
		emit_signal("finished", "idle")
	
func exit():
	jumping = false
	cancelled = false
