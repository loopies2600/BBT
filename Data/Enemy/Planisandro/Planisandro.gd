extends StaticBody2D

const CONFIGURATOR := preload("res://Data/Editor/Item/Object/Planisandro/PlanisandroConfig.tscn")

export (float) var disableTime = 1.0
export (float) var waitTime = 4.0

var auto := false
var disabled := true

onready var anim := $Animator
onready var ray := $EntityDetector
onready var timer := $HoldTimer
onready var wTimer := $WaitTimer

func resetState():
	anim.stop()
	
	disabled = true
	timer.stop()
	wTimer.stop()
	
	anim.play("Deploy")
	
	if auto:
		_fireTimer()
		
func _ready():
	var _unused = timer.connect("timeout", self, "_holdTimerTimeout")
	_unused = wTimer.connect("timeout", self, "_waitTimerTimeout")
	
	resetState()
	
func _physics_process(_delta):
	if Main.editing: return
	
	if auto:
		ray.enabled = false
	else:
		ray.enabled = !disabled
	
	if !disabled:
		anim.play("Holding" if ray.is_colliding() else "Idle")
	
		if ray.is_colliding():
			_fireTimer()
	
func _fireTimer():
	if !timer.is_stopped(): return
	
	timer.start(disableTime)

func _holdTimerTimeout():
	disabled = true
	anim.play("Exit")
	
	wTimer.start(waitTime)
	
func _waitTimerTimeout():
	resetState()
