extends StateMachine

func _ready():
	states_map = { "idle" : $Idle,
				   "crouch" : $Crouch,
				   "move" : $Move,
				   "air" : $Air,
				   "dash" : $Dash,
				   "dead" : $Dead,
				   "slide" : $Slide,
				   "editor" : $Editor,
				   "win" : $Win,
				   "rocket" : $Rocket,
				   "walled" : $Walled,
				   "look_up" : $Gaze }
