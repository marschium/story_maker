extends WindowDialog

signal text_selected(text)

var split_text = []
var selected_keywords = []

# Called when the node enters the scene tree for the first time.
func _ready():
    pass
    
func setup(text, keyword_options):    
    split_text = text.split("_")
    $"VBoxContainer/Label".text = text
    for i in range(len(split_text)):
        var option_select = OptionButton.new()
        $"VBoxContainer/OptionContainer".add_child(option_select)
        option_select.connect("item_selected", self, "_on_OptionButton_selected", [option_select, i])
        selected_keywords.append(keyword_options[0])
        for keyword in keyword_options:
            option_select.add_item(keyword)
    _update_text()
    
func _on_OptionButton_selected(item_idx, option_button, idx):
    var selected = option_button.get_item_text(item_idx)
    selected_keywords[idx] = selected
    _update_text()

func _update_text():
    var output = ""
    var i = 0
    for frag in split_text:
        output += frag + " "
        output += selected_keywords[i] + " "
        i += 1
    $"VBoxContainer/Label".text = output.strip_edges()

func _on_OkButton_pressed():
    emit_signal("text_selected", $"VBoxContainer/Label".text)
    
