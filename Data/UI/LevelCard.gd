extends Node2D

const CHARPAD := 10
const TIMEOUT := 4.0

onready var a := $Author
onready var l := $Level

onready var lName : String = Main.level.lName
onready var aName : String = Main.level.lAuthor

var _time := 0.0
var _timeoutTime := 0.0
var tgtY := 8
var animStart := true

var aRectLength := 32
var lRectLength := 32

func _ready():
	# invertir aName bwajajja
	var invertedAuthorName := ""
	
	for i in range(aName.length()):
		invertedAuthorName += aName[(aName.length() - 1) - i]
	
	aName = invertedAuthorName
	
func _process(delta):
	position.y = lerp(position.y, tgtY, 8 * delta)
	a.rect_size.x = lerp(a.rect_size.x, aRectLength, 16 * delta)
	l.rect_size.x = lerp(l.rect_size.x, lRectLength, 16 * delta)
	
	_time += delta
	
	if _time >= 0.02:
		_time = 0.0
		
		if aName:
			a.text += aName[0]
			
			if !animStart:
				aRectLength += CHARPAD
				
			aName.erase(0, 1)
			
		if lName:
			l.text += lName[0]
			
			if !animStart:
				lRectLength += CHARPAD
				
			lName.erase(0, 1)
		
		animStart = false
	
	if !aName && !lName:
		_timeoutTime += delta
	
	if _timeoutTime >= TIMEOUT:
		aName += " "
		lName += " "
		
		tgtY = -32
	
	if _timeoutTime >= TIMEOUT + 0.4:
		queue_free()
