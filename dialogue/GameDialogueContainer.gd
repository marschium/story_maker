extends PanelContainer

class DialogueState:
    
    var text = ""
    var options = {}
    
export var state_dict = {}
var dialogue_state
var DialogueLabel = load("res://dialogue/DialogueLabel.tscn")
var dialogue_label = null

# Called when the node enters the scene tree for the first time.
func _ready():
    pass
    
func _setup_state(state, dict):    
    state.text = dict["text"]
    var options = dict.get("options")
    if options:
        for option_name in options:
            var option_state = DialogueState.new()
            _setup_state(option_state, options[option_name])
            state.options[option_name] = option_state
            
func _show_dialogue_state():   
    for c in $VBox/OptionContainer.get_children():
        $VBox/OptionContainer.remove_child(c)
    if dialogue_label:
        $VBox/DialogueContainer.remove_child(dialogue_label)
        dialogue_label.queue_free()
    dialogue_label = DialogueLabel.instance()
    dialogue_label.text_to_show = dialogue_state.text
    dialogue_label.connect("finished", self, "_on_DialogueLabel_finished")
    $VBox/DialogueContainer.add_child(dialogue_label)
    dialogue_label.set_process(true)
    
func setup():    
    var start_state = DialogueState.new()
    _setup_state(start_state, state_dict)            
        
    var view_size = get_viewport().size
    rect_size = Vector2(view_size.x, view_size.y / 6)
    rect_position = Vector2(0, view_size.y - rect_size.y)
    
    _change_to_state(start_state)

func _change_to_state(state):
    dialogue_state = state
    _show_dialogue_state()
    
func _on_OptionButton_pressed(state_selected):
    _change_to_state(state_selected)

func _on_DialogueLabel_finished():
    if dialogue_state.options:
        if len(dialogue_state.options) == 1 && dialogue_state.options.has(""):
            # default (no option)
            yield (get_tree().create_timer(1), "timeout")
            _change_to_state(dialogue_state.options[""])
        else:
            # options with names
            for option in dialogue_state.options.keys():
                var b = Button.new()
                b.text = option
                b.connect("pressed", self, "_on_OptionButton_pressed", [dialogue_state.options[option]])
                $VBox/OptionContainer.add_child(b)
