extends State

func enter(_msg := {}):
	randomize()
	
	owner.collisionBox.set_deferred("disabled", true)
	
	Main.cam.target = null
	
	owner.velocity = Vector2.ZERO
	owner.doGravity = false
	owner.global_position = owner.spawnPos
	
	# random dance
	var danceChance := 10
	
	if randi() % danceChance == 0:
		owner.anim.play("Dance")
	else:
		owner.anim.play("Wait")
	
func physics_update(_delta):
	owner.velocity *= owner.damping
	
	owner.dir = 1
	
	if !Main.editing:
		emit_signal("finished", "idle")
	
func exit():
	owner.collisionBox.set_deferred("disabled", false)
	
	owner.doGravity = true
	owner.spawnPos = owner.global_position
