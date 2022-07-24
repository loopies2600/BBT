extends Node2D

const RANDWELCOME := ["I wonder if anyone reads these things...", "I should get paid for this", "Godot is cool :)", "Sugar free (i think)", "Video game lamps use real electricity", "Now using Newgrounds API", "I should get paid for this"]

onready var label := $TextDisplay
onready var playBt := $PlayButton
onready var musBt := $MusButton
onready var sndBt := $SndButton
onready var bg := $BennettBG
onready var logo := $Title
onready var buildnum := $VersionNumber

var tgCol := Color(0.25, 0.25, 0.25, 1.0)

func _ready():
	buildnum.text += OS.get_name().to_upper()
	
	var _unused = playBt.connect("pressed", self, "_playPress")
	
	Main.cam.current = false
	Main.cam.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	
	randomize()
	
	Main.ot.setTouchControls(false)
	Main.cam.current = false
	Main.cam.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	label.text = "\n* BENNETT BOY'S TROUBLE *"
	
	yield(get_tree().create_timer(0.5), "timeout")
	label.text += "\n2022 Loopies"
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	label.text += "\n\n%s" % RANDWELCOME[randi() % RANDWELCOME.size()]
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	label.text += "\n\n--- TILE LIST ---\n"
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	for tile in Main.level.tile_set.get_tiles_ids():
		label.text += "%s, " % Main.level.tile_set.tile_get_name(tile)
		yield(get_tree().create_timer(0.025), "timeout")
		
	yield(get_tree().create_timer(4.0), "timeout")
	
	playBt.visible = !playBt.visible
	musBt.visible = !musBt.visible
	sndBt.visible = !sndBt.visible
	logo.visible = !logo.visible
	label.visible = !label.visible
	
	tgCol = Color.white
	
func _process(delta):
	bg.modulate = lerp(bg.modulate, tgCol, 8 * delta)
	
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
