extends ScrollContainer


var template_dialog = preload("res://dialogue/TemplateDialog.tscn")
signal template_selected(text)

var keyword_options = []

# Called when the node enters the scene tree for the first time.
func _ready():    
    var file = File.new()
    file.open("res://dialogue/templates.txt", File.READ)
    while not file.eof_reached(): 
        var button = Button.new()
        button.align = 1
        button.text = file.get_line()
        button.size_flags_horizontal = SIZE_EXPAND_FILL
        button.connect("pressed", self, "_on_Button_pressed", [button.text])
        $VBoxContainer.add_child(button)

    file = File.new()
    file.open("res://dialogue/keywords.txt", File.READ)
    while not file.eof_reached():
        keyword_options.append(file.get_line())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _on_Dialog_text_selected(text, dialog):
    emit_signal("template_selected", text)
    remove_child(dialog)
    dialog.queue_free()

func _on_Button_pressed(text):
    var dialog = template_dialog.instance()
    add_child(dialog)
    dialog.connect("text_selected", self, "_on_Dialog_text_selected", [dialog])
    dialog.setup(text, keyword_options)
    dialog.popup()
