extends KinematicBody2D
class_name Kinematos

signal died

export (float) var dustSpawnRate = 0.025
export (float) var dustMinVel = 500.0
export (float) var gravity = 25.0

var doGravity := true

var velocity := Vector2()
var upDirection := Vector2.UP

onready var spawnPos := global_position

var _doDust := false

func _ready():
	_dustLoop()
	
func _physics_process(delta):
	scale.y = lerp(scale.y, -upDirection.y, 16 * delta)
	
	_dustTrigger()
	
func _dustTrigger():
	if velocity.length() > dustMinVel:
		_doDust = true
	else:
		_doDust = false
	
func _dustLoop():
	if !visible: return
	
	if _doDust:
		var dust = load("res://Data/Particles/FastDust.tscn").instance()
	
		get_tree().get_root().add_child(dust)
		dust.global_position = global_position
	
	yield(get_tree().create_timer(dustSpawnRate), "timeout")
	_dustLoop()
	
func kill():
	emit_signal("died")
	
	Global.plop(global_position)
	queue_free()
