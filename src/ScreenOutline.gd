extends Node2D

export var screen_size = Vector2(800, 600)


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _draw():
    var r = Rect2(Vector2(0,0), screen_size)
    draw_rect(r, Color(255, 255, 255), false, 1)
