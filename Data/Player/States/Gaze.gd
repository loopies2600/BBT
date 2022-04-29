extends State

onready var timer := $CamTimer

func _ready():
	var _unused = timer.connect("timeout", self, "_camTimerEnd")
	
func enter(_msg := {}):
	owner.slideDownSlopes = true
	owner._doDust = false
	
	owner.anim.play("LookUp")
	
	timer.start(0.8)
	
func _camTimerEnd():
	owner.camOffset.y = 64 * owner.upDirection.y
	
func physics_update(_delta):
	owner.velocity *= owner.damping
	
	if owner.canInput:
		if owner.iDir && owner.iDir != owner.dir:
			owner.dir = owner.iDir
			owner.anim.stop()
			owner.anim.play("LookUpTurn")
			
		if !owner.is_on_floor():
			emit_signal("finished", "air")
			
		if !owner.closeToCeiling():
			if Input.is_action_just_pressed("jump"):
				emit_signal("finished", "air", {"jumpHeight" : owner.jumpHeight})
				
			if !Input.is_action_pressed("look_up"):
				emit_signal("finished", "idle")
	
func exit():
	owner.camOffset.y = 0
	timer.stop()
