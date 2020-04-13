extends Area2D

var hovered = false
var bounds = Vector2(0,0)
var button_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
    #connect("mouse_entered", self, "_mouse_over", [true])
    #connect("mouse_exited", self, "_mouse_over", [false])
    bounds = get_viewport().size

func _input(event): 
    return

#func _mouse_over(value):
#    self.hovered = value

func initalise(image):
    var tex = ImageTexture.new()
    tex.create_from_image(image)
    var s = Sprite.new()
    s.texture = tex    
    s.set_name("Sprite")
    add_child(s)
    s.set_owner(self)
    var shape = RectangleShape2D.new()
    shape.extents = image.get_size() / 2
    $CollisionShape2D.shape = shape  
    
func get_item_to_save():
    var sprite = $Sprite.duplicate()
    sprite.position = position
    return sprite
    
func save_resources_to_packer(packer):
    packer.add_file($Sprite.texture.resource_path, $Sprite.texture.resource_path)

func _on_EditorElement_input_event(viewport, event, shape_idx):                
    if event is InputEventMouseMotion and self.button_down:
        position = event.position
        if position.x < 0:
            position.x = 0
        if position.y < 0:
            position.y = 0
        if position.x > bounds.x:
            position.x = bounds.x
        if position.y > bounds.y:
            position.y = bounds.y    
    
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:        
        if event.is_pressed():
            self.button_down = true
        else:
            self.button_down = false
