
extends Area2D

var pos_up
var pos_down

func _ready():
	pos_up = get_node("pos_up").get_pos()
	pos_down = get_node("pos_down").get_pos()
	
func get_stairs_target(var pos):
	# finds useful target (i.e. moving down when on top of stairs)
	var dist_up = pos_up.distance_to(pos)
	var dist_down = pos_down.distance_to(pos)

	if dist_up > dist_down:
		return pos_up
	else:
		return pos_down
