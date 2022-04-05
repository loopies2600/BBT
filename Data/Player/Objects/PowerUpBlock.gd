extends Area2D

enum PowerUps { ROCKET }

export (PowerUps) var pwr = PowerUps.ROCKET

func _ready():
	var _unused = connect("body_entered", self, "_playerEnter")
	
func _playerEnter(body):
	var pwrName := "Rocket" if pwr == PowerUps.ROCKET else ""
	
	if body is Player:
		if body.fsm.current_state.name == pwrName:
			Main.plop(body.global_position)
			
			body.fsm._change_state("air")
			return
			
		Main.plop(body.global_position)
		body.fsm._change_state(pwrName.to_lower())
