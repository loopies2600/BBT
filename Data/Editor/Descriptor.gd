extends CenterContainer

onready var l := $Label
onready var timer := $Timeout

var on := false

func _ready():
	var _unused = timer.connect("timeout", self, "_onTimeout")
	
func msg(msg := ""):
	if l.text == msg: return
	
	l.text = msg
	on = true
	
	timer.start()
	
func _process(delta):
	modulate.a = lerp(modulate.a, 1.0 if on else 0.0, 16 * delta)
	
func _onTimeout():
	on = false
