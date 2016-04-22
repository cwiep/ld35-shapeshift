
extends Area2D

export var allowed = ""
# couldn't figure out, how to export an editable array...
export var allowed2 = ""

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func is_allowed(person_type):
	return person_type == allowed or person_type == allowed2