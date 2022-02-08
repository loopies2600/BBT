extends State

const HARD_HAT = preload("res://Data/Player/Objects/HardHat.tscn")

func enter(msg := {}):
	var velocity := Vector2(owner.maxSpd * owner.dir * 0.75, owner.jumpHeight * owner.upDirection.y * 1.25)
	
	if msg.has("velocity"):
		velocity = msg.velocity
		
	if is_instance_valid(owner.holding):
		owner.throwObject()
	
	# spawnea el casco y aplica velocidad
	if !msg.has("noAnim"):
		var newHat = HARD_HAT.instance()
		get_tree().get_root().add_child(newHat)
		
		newHat.global_position = owner.global_position
		newHat.velocity = Vector2(rand_range(-velocity.x, velocity.x), velocity.y * 1.25)
		newHat.upDirection = owner.upDirection
	else:
		velocity = Vector2.ZERO
		
	
	# señal muerte y animar
	owner.emit_signal("died")
	owner.anim.play("Death")
	owner._doDust = true
	
	# desactivar colisiones y sacudir camara
	Global.plop(owner.global_position)
	owner.cam.shake(3, 3)
	
	owner.cam.set_as_toplevel(true)
	owner.cam.global_position = owner.global_position
	
	owner.collisionBox.set_deferred("disabled", true)
	owner.canInput = false
	
	# mover
	owner.velocity = velocity
	
	# esperar y reiniciar
	yield(get_tree().create_timer(owner.resetDelay * 0.75), "timeout")
	
	owner.levelManager.restart()
