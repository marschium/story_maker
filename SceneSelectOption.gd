extends PanelContainer

signal selected()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func set_screenshot(screenshot):
    var img = screenshot.get_data()
    img.resize($TextureButton.rect_size.x, $TextureButton.rect_size.y)
    var tex = ImageTexture.new()
    tex.create_from_image(img)
    $TextureButton.texture_normal = tex

func _on_TextureButton_pressed():
    emit_signal("selected")
