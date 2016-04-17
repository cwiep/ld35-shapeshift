
extends Area2D

export var allowed = "guest_w"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func is_allowed(person_type):
	return person_type == allowed