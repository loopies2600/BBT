extends State

func enter(_msg := {}):
	if p.iDir && p.iDir != p.dir:
		p.dir = p.iDir
		p.anim.play("Turn")
		yield(p.anim, "animation_finished")
		p.anim.play("Walk")
		
	p.anim.play("Walk")
	
func physics_update(_delta):
	p.velocity.x = clamp(p.velocity.x + p.accel * p.iDir, -p.maxSpd, p.maxSpd) / p.weight
	
	if p.canInput:
		if !p.iDir:
			p.setState(0)
		else:
			p.dir = p.iDir
			
		if !p.is_on_floor():
			p.setState(3)
		
		if Input.is_action_just_pressed("jump"):
			p.setState(3, {"jumpHeight" : p.jumpHeight})
			
		if Input.is_action_just_pressed("look_down"):
			p.setState(1)
