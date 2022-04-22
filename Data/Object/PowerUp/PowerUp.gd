extends Area2D

enum PowerUps { ROCKET }

export (PowerUps) var pwr = PowerUps.ROCKET

onready var anim := $Gachapon/Animator

func resetState():
	anim.play("Idle")
	
func _ready():
	add_to_group("Gachapons")
	
	var _unused = connect("body_entered", self, "_playerEnter")
	
func _playerEnter(body):
	var pwrName := "Rocket" if pwr == PowerUps.ROCKET else ""
	
	if body is Player:
		if body.fsm.current_state.name == pwrName:
			Main.plop(body.global_position)
			
			body.fsm._change_state("air")
			anim.play("Idle")
			return
		
		anim.play("Open")
		Main.plop(body.global_position)
		body.fsm._change_state(pwrName.to_lower())
