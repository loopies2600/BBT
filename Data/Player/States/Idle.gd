extends State

func enter(_msg := {}):
	p.canDash = true
	p.canWallJump = true
	
	Main.cam.target = p
	
	p.slideDownSlopes = false
	p._doDust = false
	
	p.anim.play("Idle")
	
func physics_update(_delta):
	p.velocity *= p.damping
	
	if p.canInput:
		if p.iDir:
			p.setState(2)
			
		if !p.is_on_floor():
			p.setState(3)
			
		if Input.is_action_just_pressed("jump"):
			p.setState(3, {"jumpHeight" : p.jumpHeight})
			
		if Input.is_action_just_pressed("look_up"):
			p.setState(11)
			
		if Input.is_action_pressed("look_down"):
			p.setState(1)
