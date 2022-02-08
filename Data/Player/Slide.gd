extends State

var time := 0.0

func enter(_msg := {}):
	owner.velocity = Vector2.ZERO
	owner.anim.play("Slide")
	
	var boost : int = owner.global_position.x + (owner.slideDistance * owner.dir)
	
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(owner, "global_position:x", null, boost, owner.slideDuration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	tween.queue_free()
	
	emit_signal("finished", "idle")
	
func physics_update(_delta):
	if sign(owner.velocity.y) == -sign(owner.upDirection.y):
		emit_signal("finished", "air")
