extends Area2D

var hovered = false
var bounds = Vector2(0,0)
var button_down = false
var modify_key = false

# Called when the node enters the scene tree for the first time.
func _ready():
    bounds = get_viewport().size

func _input(event): 
    return

func _process(delta):
    modify_key = false
    if Input.is_key_pressed(KEY_SHIFT):
        modify_key = true

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
    sprite.scale = scale
    sprite.rotation = rotation
    return sprite
    
func save_resources_to_packer(packer):
    packer.add_file($Sprite.texture.resource_path, $Sprite.texture.resource_path)

func _on_EditorElement_input_event(viewport, event, shape_idx):                
    
    # move
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
    
    # scale and rotate
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_WHEEL_DOWN \
    and self.button_down:        
        if self.modify_key:
            rotation_degrees -= 10
        else:
            scale = Vector2(scale.x - 0.05, scale.y - 0.05)
        
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_WHEEL_UP \
    and self.button_down:
        if self.modify_key:
            rotation_degrees += 10
        else:
            scale = Vector2(scale.x + 0.05, scale.y + 0.05)
            
    # click        
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:        
        if event.is_pressed():
            self.button_down = true
        else:
            self.button_down = false
