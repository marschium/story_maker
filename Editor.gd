extends Control


onready var world = $VBoxContainer/HSplitContainer/VSplitContainer/ViewportContainer/Viewport/World  
onready var tab_container = $VBoxContainer/HSplitContainer/TabContainer
onready var dialogue_editor = $VBoxContainer/HSplitContainer/VSplitContainer/DialogueEditorElement
onready var value_editor = $VBoxContainer/HSplitContainer/TabContainer/Values

var state_machine = preload("res://GameStateMachine.tscn")
var value_store = preload("res://GameValueStore.tscn")

func _ready():
    pass

func _export_game():	
    # images
    var scene_to_save = world.get_scene_to_save()
    
    # global values
    var vs = value_store.instance()
    vs.lookup = value_editor.get_values()
    scene_to_save.add_child(vs)
    vs.set_owner(scene_to_save)
    
    var sm = state_machine.instance()
    sm.state_dict = dialogue_editor.get_state_machine_dict()	
    scene_to_save.add_child(sm)
    sm.set_owner(scene_to_save)
        
    var packed_scene = PackedScene.new()
    packed_scene.pack(scene_to_save)
    ResourceSaver.save("user://world.tscn", packed_scene)
    
    var packer = PCKPacker.new()
    packer.pck_start("user://game.pck")
    packer.add_file("res://main.tscn", "user://world.tscn")
    world.save_resources_to_packer(packer)
    packer.flush()

func _on_MenuButton_save_selected():
    _export_game()

func _on_Scenes_scene_added():
    world.add_scene()
    dialogue_editor.add_scene()

func _on_Scenes_scene_changed(id):
    world.change_to_scene(id)
    dialogue_editor.change_to_scene(id)

func _on_ScreenshotTimer_timeout():
    var screenshot = $VBoxContainer/HSplitContainer/VSplitContainer/ViewportContainer.screenshot()
    $VBoxContainer/HSplitContainer/TabContainer/Scenes.set_current_screenshot(screenshot)

func _on_RunButton_pressed():
    _export_game()
    OS.execute("bin/runner.exe", [])
