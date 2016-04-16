
extends Area2D

var current_state
var state_timer
const STATE = {
	"moving_right": 0,
	"moving_left": 1,
	"standing": 2
}

func _ready():
	set_fixed_process(true)
	_roll_new_state()
	
func _fixed_process(delta):
	state_timer -= delta
	if state_timer <= 0:
		_roll_new_state()
	
	if current_state == STATE["moving_right"]:
		# TODO: play anim right
		if !get_node("look_right").is_colliding():
			translate(Vector2(50 * delta, 0))
	elif current_state == STATE["moving_left"]:
		# TODO: play anim left
		if !get_node("look_left").is_colliding():
			translate(Vector2(-50 * delta, 0))

func _roll_new_state():
	state_timer = rand_range(1.5, 4.0)
	current_state = STATE[STATE.keys()[randi() % STATE.size()]]
	print(current_state)