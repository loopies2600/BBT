extends Control

onready var label := $Label
onready var editor : Node2D = get_tree().get_nodes_in_group("Editor")[0]
onready var exitBt := $Exit

var exit := false

func _mouseIn():
	editor.cursor.canPlace = false
	
func _mouseOut():
	editor.cursor.canPlace = true
	
func _ready():
	var _unused = connect("mouse_entered", self, "_mouseIn")
	_unused = connect("mouse_exited", self, "_mouseOut")
	
	_unused = exitBt.connect("pressed", self, "_onExitPress")
	
	_unused = label.get_v_scroll().connect("mouse_entered", self, "_mouseIn")
	_unused = label.get_v_scroll().connect("mouse_exited", self, "_mouseOut")
	
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = false
	
func _onExitPress():
	exit = true
	
	yield(get_tree().create_timer(0.15), "timeout")
	
	get_tree().get_nodes_in_group("Cursor")[0].canPlace = true
	queue_free()
	
func _process(delta):
	modulate.a = lerp(modulate.a, 1.0 if !exit else 0.0, 20 * delta)
