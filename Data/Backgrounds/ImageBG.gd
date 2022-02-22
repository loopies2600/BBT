extends ParallaxBackground

func _ready():
	var _unused = get_tree().connect("files_dropped", self, "_fileDrop")
	
func _fileDrop(files, _screen):
	_setTexture(files[0])
	
func _setTexture(path := ""):
	if !path.ends_with(".png"): return
	
	var img = Image.new()
	var error = img.load(path)
	
	if error != OK: return
	
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	$ParallaxLayer/TextureRect.texture = tex
