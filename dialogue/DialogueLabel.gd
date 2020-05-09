extends Label

signal finished()
export var text_to_show = ""
export var chars_per_sec = 2

var char_idx = 0;
var wait = 0;
var counter = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
    wait = 1 / chars_per_sec


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if char_idx < text_to_show.length():
        counter += delta
        if counter >= wait:
            counter = 0;
            text += text_to_show[char_idx]
            char_idx += 1
            if char_idx >= text_to_show.length():
                emit_signal("finished")
