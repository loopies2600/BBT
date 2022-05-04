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
	if get_parent().bgTex:
		rect.texture = get_parent().bgTex
		
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
	
	while rect.rect_size.x < get_viewport().size.x * 4:
		rect.rect_size.x += rect.texture.get_size().x
		
	while rect.rect_size.y < get_viewport().size.y * 4:
		rect.rect_size.y += rect.texture.get_size().y
	
	$ParallaxLayer.motion_mirroring = rect.rect_size
	
func _fileDrop(files, _screen):
	if Main.level.get_node("Player"): return
	
	var valid : bool= files[0].ends_with("png") || files[0].ends_with("jpg")
	
	if !valid: return
	
	_setTexture(files[0])
	
func _setTexture(path := ""):
	var img = Image.new()
	var error = img.load(path)
	
	if error != OK: return
	
	img.compress(Image.COMPRESS_S3TC, Image.COMPRESS_SOURCE_GENERIC, 0.5)
	
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	rect.texture = tex
	get_parent().bgTex = tex
	
	if mode == Modes.TILE:
		_resizeRect()
