extends ViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func screenshot():    
    var img = $Viewport.get_texture().get_data()
    img.flip_y()
    #yield(get_tree(), "idle_frame")
    #yield(get_tree(), "idle_frame")
    var tex = ImageTexture.new()
    tex.create_from_image(img)
    return tex

func _gui_input(event):
    #print(event)
    get_node('Viewport').unhandled_input(event)
