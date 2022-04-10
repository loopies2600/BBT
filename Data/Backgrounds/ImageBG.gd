extends ParallaxBackground

enum Modes {TILE, STRETCH}
onready var rect := $ParallaxLayer/TextureRect

var mode = Modes.TILE setget _setMode
 
func _setMode(md : int):
	if mode == md: return
	
	mode = md
	
	match mode:
		Modes.TILE:
			scroll_base_scale = Vector2.ONE
			rect.stretch_mode = TextureRect.STRETCH_TILE
			_resizeRect()
		Modes.STRETCH:
			scroll_base_scale = Vector2()
			rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
func _ready():
	$ParallaxLayer.owner = get_parent()
	rect.owner = get_parent()
	
	var _unused = get_tree().connect("files_dropped", self, "_fileDrop")
	
	_resizeRect()
	
func _process(_delta):
	if mode == Modes.STRETCH:
		rect.rect_size = Vector2(416, 240) / Main.level.get_canvas_transform().get_scale()
	else:
		if Main.editing:
			scroll_offset = get_parent().get_canvas_transform().origin
		
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
	
	if mode == Modes.TILE:
		_resizeRect()
