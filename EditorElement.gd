extends Node2D

var hovered = false
var bounds = Vector2(0,0)
var mouse_over = false
var button_down = false
var mouse_offset = Vector2(0, 0)
var modify_key = false

# Called when the node enters the scene tree for the first time.
func _ready():
    bounds = get_viewport().size

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
    shape.extents = image.get_size()
    $Button.rect_position = (image.get_size() / 2) * -1
    $Button.rect_min_size = image.get_size()  
    
func get_item_to_save():
    var sprite = $Sprite.duplicate()
    sprite.position = position
    sprite.scale = scale
    sprite.rotation = rotation
    return sprite
    
func save_resources_to_packer(packer):
    packer.add_file($Sprite.texture.resource_path, $Sprite.texture.resource_path)

func _input(event):                
    
    # move
    if event is InputEventMouseMotion and self.button_down:
        position = event.position - mouse_offset 
        get_tree().set_input_as_handled()
    
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

func _on_EditorElement_mouse_entered():
    pass
    #self.mouse_over = true


func _on_EditorElement_mouse_exited():
    pass
    #self.mouse_over = false
    #self.button_down = false


func _on_Button_button_down():    
    var e = get_global_mouse_position()
    self.mouse_offset = Vector2(e.x - position.x, e.y - position.y)
    self.button_down = true
    self.mouse_over = true


func _on_Button_button_up():  
    self.button_down = false
    self.mouse_over = false
