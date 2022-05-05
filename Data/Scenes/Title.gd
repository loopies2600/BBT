extends Node2D

onready var playBt := $PlayButton
onready var musBt := $MusButton
onready var sndBt := $SndButton

func _ready():
	var _unused = playBt.connect("pressed", self, "_playPress")
	
	Main.cam.current = false
	Main.cam.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	
func _playPress():
	playBt.disabled = true
	
	var trans = load("res://Data/UI/Transition/Transition.tscn").instance()
	Main.add_child(trans)
	
	yield(trans, "transition_ended")
	
	Main.changeScene(Main.EDITOR)
	
	AudioServer.set_bus_mute(1, !musBt.pressed)
	AudioServer.set_bus_mute(2, !sndBt.pressed)
	
func _exit_tree():
	Main.cam.global_position = Vector2()
