
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.is_action_released("ui_right") and !event.is_echo():
		if get_node("Sprite").get_frame() == 0:
			get_node("Sprite").set_frame(1)
		else:
			get_tree().change_scene("res://house.tscn")
	elif event.is_action_released("ui_left") and !event.is_echo():
		get_node("Sprite").set_frame(0)


