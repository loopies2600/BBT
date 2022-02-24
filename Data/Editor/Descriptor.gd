extends CenterContainer

onready var l := $Label
onready var timer := $Timeout

func _ready():
	var _unused = timer.connect("timeout", self, "_onTimeout")
	
func msg(msg := ""):
	l.text = msg
	show()
	
	timer.start()
	
func _onTimeout():
	hide()
