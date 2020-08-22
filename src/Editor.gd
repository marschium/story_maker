extends Control


onready var world = $VBoxContainer/HSplitContainer/VSplitContainer/ViewportContainer/Viewport/World  
onready var tab_container = $VBoxContainer/HSplitContainer/TabContainer
onready var dialogue_editor = $VBoxContainer/HSplitContainer/VSplitContainer/DialogueEditorElement
onready var value_editor = $VBoxContainer/HSplitContainer/TabContainer/Values

var state_machine = preload("res://GameStateMachine.tscn")
var value_store = preload("res://GameValueStore.tscn")

func _ready():
    pass
    
func _save_to_user_data():
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

func _save_to_disk():      
    var file_picker = FileDialog.new()
    file_picker.add_filter("*.zip ; ZIP archives")
    file_picker.access = 2 #ACCESS_FILESYSTEM 
    file_picker.set_current_dir("user://")
    add_child(file_picker)   
    file_picker.popup(Rect2(0, 0, 500, 500)) 
    file_picker.invalidate()
    var f = yield(file_picker, "file_selected")
    var f_exe = f.replace(".zip", ".exe").rsplit("/", true, 1)[1]
    var f_pck = f_exe.replace(".exe", ".pck")
    var f_folder = f_exe.replace(".exe", "")
    
    var d = Directory.new()
    var data_dir = OS.get_user_data_dir()
    var exe = OS.get_executable_path()
    d.make_dir(data_dir + "/" + f_folder)
    d.copy(exe, data_dir + "/" + f_folder + "/" + f_exe)
    d.copy("user://world.tscn", data_dir + "/" + f_folder + "/world.tscn")
    d.copy("user://game.pck", data_dir + "/" + f_folder + "/game.pck")
    d.copy("res://runner.pck", data_dir + "/" + f_folder + "/" + f_pck)
    OS.execute("powershell", ["-command", "Compress-Archive", "-Path",  data_dir + "/" + f_folder + "/", "-DestinationPath", f])
    

func _on_MenuButton_save_selected():
    _save_to_user_data()
    _save_to_disk()

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
    _save_to_user_data()
    var d = Directory.new()
    d.copy(OS.get_executable_path(), "user://runner.exe")
    d.copy("runner.pck", "user://runner.pck")
    OS.execute(OS.get_user_data_dir() + "/runner.exe", [])
