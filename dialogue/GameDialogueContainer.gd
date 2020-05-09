extends PanelContainer

class DialogueState:
    
    var text = ""
    var options = {}
    
export var state_dict = {}
var dialogue_state

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
    
func setup():    
    var start_state = DialogueState.new()
    dialogue_state = start_state
    _setup_state(start_state, state_dict)
            
        
    var view_size = get_viewport().size
    rect_size = Vector2(view_size.x, view_size.y / 6)
    rect_position = Vector2(0, view_size.y - rect_size.y)
    
    $DialogueLabel.text_to_show = start_state.text
    $DialogueLabel.set_process(true)


func _on_DialogueLabel_finished():
    print("finished")
    # TODO is option is blank swith to that
