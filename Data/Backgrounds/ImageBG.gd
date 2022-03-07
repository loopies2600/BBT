extends ParallaxBackground

onready var rect := $ParallaxLayer/TextureRect

func _ready():
	var _unused = get_tree().connect("files_dropped", self, "_fileDrop")
	
	_resizeRect()
	
func _resizeRect():
	rect.rect_size = Vector2(0, 96)
	
	while rect.rect_size.x < get_viewport().size.x * 2:
		rect.rect_size.x += rect.texture.get_size().x
		
	while rect.rect_size.y < get_viewport().size.y * 2:
		rect.rect_size.y += rect.texture.get_size().y
	
	$ParallaxLayer.motion_mirroring = rect.rect_size
	
func _fileDrop(files, _screen):
	_setTexture(files[0])
	
func _setTexture(path := ""):
	var img = Image.new()
	var error = img.load(path)
	
	if error != OK: return
	
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	rect.texture = tex
	
	_resizeRect()
