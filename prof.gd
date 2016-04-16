
extends Area2D

var current_state
var state_timer
const STATE = {
	"moving_right": 0,
	"moving_left": 1,
	"standing": 2
}

var sprite_node
var animation_timer

func _ready():
	set_fixed_process(true)
	_roll_new_state()
	sprite_node = get_node("Sprite")
	animation_timer = 0
	
func _fixed_process(delta):
	state_timer -= delta
	if state_timer <= 0:
		_roll_new_state()
	
	animation_timer += delta
	if animation_timer >= 0.8:
		animation_timer = 0
	
	if current_state == STATE["moving_right"]:
		if !get_node("look_right").is_colliding():
			translate(Vector2(50 * delta, 0))
			# animation
			sprite_node.set_flip_h(true)
			sprite_node.set_frame(int(animation_timer / 0.2))
	elif current_state == STATE["moving_left"]:
		if !get_node("look_left").is_colliding():
			# move
			translate(Vector2(-50 * delta, 0))
			# animation
			sprite_node.set_flip_h(false)
			sprite_node.set_frame(int(animation_timer / 0.2))
	else:
		# standing
		sprite_node.set_frame(0)

func _roll_new_state():
	state_timer = rand_range(1.5, 4.0)
	current_state = STATE[STATE.keys()[randi() % STATE.size()]]
