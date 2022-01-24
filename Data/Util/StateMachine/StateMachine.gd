extends Node
class_name StateMachine

# warning-ignore:unused_signal
signal state_changed(current_state)

export(NodePath) var START_STATE
var states_map = {}

var current_state = null
var previous_state := ""
var _active = false setget set_active

var firstConnection := true

func _ready():
	yield(owner, "ready")
	initialize(START_STATE)
	
	for child in get_children():
		child.connect("finished", self, "_change_state")
		
func initialize(start_state, msg := {} ):
	set_active(true)
	current_state = get_node(start_state)
	current_state.enter(msg)

func set_active(value):
	_active = value
	set_physics_process(value)
	set_process(value)
	set_process_input(value)
	
	if not _active:
		current_state = null

func _input(event):
	if not _active:
		return
	current_state.handle_input(event)

func _process(delta):
	if not _active:
		return
	current_state.update(delta)
	
func _physics_process(delta):
	if not _active:
		return
	current_state.physics_update(delta)

func _change_state(state_name : String, msg := {} ) -> void:
	if not _active:
		return
		
	if state_name == current_state.name.to_lower() && !msg:
		return
	else:
		previous_state = current_state.name.to_lower()
		
	current_state.exit()
	
	current_state = states_map[state_name]
	
	current_state.enter(msg)
	
