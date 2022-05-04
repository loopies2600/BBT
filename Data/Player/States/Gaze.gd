extends State

onready var timer := $CamTimer

func _ready():
	var _unused = timer.connect("timeout", self, "_camTimerEnd")
	
func enter(_msg := {}):
	p.slideDownSlopes = true
	p._doDust = false
	
	p.anim.play("LookUp")
	
	timer.start(0.8)
	
func _camTimerEnd():
	p.camOffset.y = 64 * p.upDirection.y
	
func physics_update(_delta):
	p.velocity *= p.damping
	
	if p.canInput:
		if p.iDir && p.iDir != p.dir:
			p.dir = p.iDir
			p.anim.stop()
			p.anim.play("LookUpTurn")
			
		if !p.is_on_floor():
			p.setState(3)
			
		if !p.closeToCeiling():
			if Input.is_action_just_pressed("jump"):
				p.setState(3, {"jumpHeight" : p.jumpHeight})
				
			if !Input.is_action_pressed("look_up"):
				p.setState(0)
	
func exit():
	p.camOffset.y = 0
	timer.stop()
