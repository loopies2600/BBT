extends State

func enter(msg := {}):
	p.canDash = false
	
	p.sounds[1].play()
	p.anim.play("Dash")
	
	p._doDust = true
	
	var left := int(Input.is_action_pressed("left"))
	var right := int(Input.is_action_pressed("right"))
	var up := int(Input.is_action_pressed("look_up"))
	var down := int(Input.is_action_pressed("look_down"))
	
	var angle := Vector2(right - left, down - up).angle()
	
	if angle == 0.0: angle = 0.0 if p.dir == 1 else PI
	
	if !msg.has("noBoost"):
		p.velocity += Vector2((p.maxSpd * 2) / p.weight, 0).rotated(angle)
	
func physics_update(_delta):
	if p.get_slide_count():
		p.velocity.x = 0
		p.setState(3)
