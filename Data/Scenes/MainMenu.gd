extends Node2D

onready var buttons := [$PlayButton, $ConfigButton, $DecryptButton]

var selected := 0
var transitioning := false

func _ready():
	buttons[selected].selected = true
	
func _input(event):
	if transitioning: return
	
	var dir = int(event.is_action_pressed("right")) - int(event.is_action_pressed("left"))
	
	if event.is_pressed() && !event.is_echo():
		for b in buttons:
			b.tgtAngle += deg2rad(120) * dir
			b.selected = false
		
		selected -= dir
		
		if selected > buttons.size() - 1:
			selected = 0
		if selected < 0:
			selected = buttons.size() - 1
		
		buttons[selected].selected = true
	
	if event.is_action_pressed("jump"):
		transitioning = true
		
		var trans = load("res://Data/UI/Transition/Transition.tscn").instance()
		Main.add_child(trans)
		
		yield(trans, "transition_ended")
		
		match selected:
			0:
				Main.changeScene(Main.TITLE)
				return
		
		transitioning = false
