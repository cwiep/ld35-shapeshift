
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("ui_accept") and !event.is_echo():
		get_tree().change_scene("res://house.tscn")


