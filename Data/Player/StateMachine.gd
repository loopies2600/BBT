extends StateMachine

func _ready():
	states_map = { "idle" : $Idle,
				   "crouch" : $Crouch,
				   "move" : $Move,
				   "air" : $Air,
				   "attack" : $Attack,
				   "dead" : $Dead }
