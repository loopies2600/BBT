extends Node2D

onready var mesh := $MeshVP/TimerMonitorMesh
onready var startY := global_position.y

var _time := 0.0
var isTimer := false

var timeLeft := 10 setget _setTimeLeft

func _setTimeLeft(nt : int):
	if timeLeft == nt: return
	
	timeLeft = nt
	mesh.anim.play("Refresh")
	mesh.label.text = str(timeLeft)
	
	if timeLeft == 0:
		$Animator.play("Exit")
	
func _ready():
	mesh.chara.visible = !isTimer
	mesh.label.visible = isTimer

func _process(delta):
	if !Main.level.blockTimer.is_stopped():
# warning-ignore:narrowing_conversion
		self.timeLeft = round(Main.level.blockTimer.time_left)
	
	global_position.y = startY + (sin(_time) * 8)
	_time += delta
	
func _reset():
	if isTimer: return
	
	$Animator.stop()
	$Animator.play("Deploy")
	mesh.anim.play("Refresh")
	
	mesh.rotation = Vector3()
	
	_time = 0.0
	mesh._time = 0.0
	mesh.rotSpeed += 2175.0
