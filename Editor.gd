extends Control


onready var world = $VBoxContainer/HBoxContainer/VBoxContainer/ViewportContainer/Viewport/World  
onready var tab_container = $VBoxContainer/HBoxContainer/TabContainer
onready var dialogue_editor = $VBoxContainer/HBoxContainer/VBoxContainer/DialogueEditorElement
onready var value_editor = $VBoxContainer/HBoxContainer/TabContainer/Values

var state_machine = preload("res://GameStateMachine.tscn")
var dialogue_container = preload("res://dialogue//GameDialogueContainer.tscn")
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
	
	# dialogue and logic	
	var dc = dialogue_container.instance()
	scene_to_save.add_child(dc)
	dc.set_owner(scene_to_save)
	
	var sm = state_machine.instance()
	sm.state_dict = dialogue_editor.get_dialogue()	
	scene_to_save.add_child(sm)
	sm.set_owner(scene_to_save)
	scene_to_save.move_child(sm, get_child_count() - 1) # force to the front
	
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
