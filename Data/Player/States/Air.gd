extends State

var jumping := false
var cancelled := false
var ignoreAnim := false

func enter(msg := {}):
	ignoreAnim = msg.has("ignoreAnim")
	
	if !p.god:
		if msg.has("jumpHeight"):
			p.sounds[0].pitch_scale = rand_range(0.75, 1.25)
			p.sounds[0].play()
			
			if int(msg["jumpHeight"]) != 0:
				p.recalcJumpValues(msg["jumpHeight"])
			
			jumping = true
			
			if msg.has("antiCancel"):
				p.velocity.y = 0.0
				
			p.velocity += Vector2(p.jumpVel, 0).rotated(p.upDirection.angle()).rotated(p.gfx.rotation)
		else:
			p.recalcJumpValues(p.jumpHeight)
			
	if msg.has("antiCancel"):
		cancelled = true
	
	if p.prevState == "Slide" || p.prevState == "Walled":
		p._doDust = true
		
func physics_update(_delta):
	if !ignoreAnim:
		if sign(p.velocity.y) == -sign(p.upDirection.y):
			var anim := "Fall"
			
			match p.prevState:
				"Slide":
					anim = "Dash"
				"Walled":
					anim = "WallFall"
				
			p.anim.play(anim)
		else:
			if jumping:
				var anim := "Jump"
				p.ganim.play("Jump")
				
				match p.prevState:
					"Slide":
						anim = "Dash"
						
				p.anim.play(anim)
				
	if p.canInput:
		if p.iDir:
			var valid := true
			
			if p.prevState == "Slide":
				valid = p.dir != p.iDir
			
			if valid:
				p.dir = p.iDir
				p.velocity.x = clamp(p.velocity.x + p.accel * p.iDir, -p.maxSpd, p.maxSpd)
		else:
			p.velocity.x *= p.airDamping
			
		if p.canDash:
			if Input.is_action_just_pressed("attack"):
				p.setState(4)
			
		if p.god:
			if Input.is_action_pressed("jump"):
				p.velocity.y = p.jumpHeight * p.upDirection.y
		
		if jumping && !cancelled:
			if Input.is_action_just_released("jump"):
				p.velocity.y *= 0.5
				cancelled = true
	
	if p.is_on_floor():
		p.ganim.play("FromJump")
		p.setState(0)
	
func exit():
	jumping = false
	cancelled = false
