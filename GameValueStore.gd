extends Node2D

signal changed(name, value)

export var lookup = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set(name, value):
	var current = lookup.get(name)
	lookup[name] = value
	if current != value:
		emit_signal("changed", name , value)

func get(name):
	return lookup.get(name)
