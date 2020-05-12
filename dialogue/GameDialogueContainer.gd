extends PanelContainer

signal dialogue_finished(option_selected)

var DialogueLabel = load("res://dialogue/DialogueLabel.tscn")
var dialogue_label = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass
            
func show_dialogue(text, options=[]):       
    print("Dialogue: ", text, options)
    for c in $VBox/OptionContainer.get_children():
        $VBox/OptionContainer.remove_child(c)
    if dialogue_label:
        $VBox/DialogueContainer.remove_child(dialogue_label)
        dialogue_label.queue_free()
    dialogue_label = DialogueLabel.instance()
    dialogue_label.text_to_show = text
    dialogue_label.connect("finished", self, "_on_DialogueLabel_finished")
    $VBox/DialogueContainer.add_child(dialogue_label)
    dialogue_label.set_process(true)
    
    yield(dialogue_label, "finished")
    
    # todo clear dialogue
    if options:
        for option in options:
            var b = Button.new()
            b.text = option
            b.connect("pressed", self, "_on_OptionButton_pressed", [option])
            $VBox/OptionContainer.add_child(b)
    else:
        emit_signal("dialogue_finished", null)
        
    
func setup():        
    var view_size = get_viewport().size
    rect_size = Vector2(view_size.x, view_size.y / 6)
    rect_position = Vector2(0, view_size.y - rect_size.y)
    
func _on_OptionButton_pressed(option):
    print(option)
    emit_signal("dialogue_finished", option)
