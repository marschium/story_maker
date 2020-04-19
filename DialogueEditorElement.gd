extends TextEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var keyword = ""

signal keyword_selected(word)


# Called when the node enters the scene tree for the first time.
func _ready():
    var view_size = get_viewport().size
    rect_size = Vector2(view_size.x, view_size.y / 6)
    rect_position = Vector2(0, view_size.y - rect_size.y)
    
func show_text(text, keywords):
    self.text = text
    for keyword in keywords:        
        add_keyword_color(keyword, Color(1, 0, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func set_new_keyword(word):  
    add_keyword_color(word, Color(1, 0, 0))
    text = text.replace(keyword, word)
    keyword = word

func _on_DialogueEditorElement_cursor_changed():
    var selected_word = get_word_under_cursor()
    if selected_word == keyword:
        emit_signal("keyword_selected", selected_word)
