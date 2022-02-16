extends State

const HARD_HAT = preload("res://Data/Player/Objects/HardHat.tscn")

func enter(msg := {}):
	var velocity := Vector2(owner.velocity.x, owner.jumpHeight * owner.upDirection.y * 6)
	
	if msg.has("velocity"):
		velocity = msg.velocity
		
	if is_instance_valid(owner.holding):
		owner.throwObject()
	
	# spawnea el casco y aplica velocidad
	if !msg.has("noAnim"):
		var newHat = HARD_HAT.instance()
		owner.get_parent().add_child(newHat)
		
		newHat.global_position = owner.global_position
		newHat.velocity = velocity * 1.25
		newHat.upDirection = owner.upDirection
	else:
		velocity = Vector2.ZERO
		
	
	# señal muerte y animar
	owner.emit_signal("died")
	owner.anim.play("Death")
	owner._doDust = true
	
	# desactivar colisiones y sacudir camara
	get_tree().get_root().get_node("Main").plop(owner.global_position)
	owner.levelManager.cam.shake(3, 3)
	
	owner.collisionBox.set_deferred("disabled", true)
	owner.canInput = false
	
	# mover
	owner.velocity = velocity
	
	# esperar y reiniciar
	yield(get_tree().create_timer(owner.resetDelay * 0.75), "timeout")
	
	owner.levelManager.restart()
