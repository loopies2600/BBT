extends Node2D

onready var buttons := [$PlayButton, $ConfigButton, $DecryptButton]

var selected := 0

func _ready():
	buttons[selected].selected = true
	
func _input(event):
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
