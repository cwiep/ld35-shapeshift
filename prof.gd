
extends Area2D

var current_state
var state_timer
var roll_states
const STATE = [
	"moving_right",
	"moving_left",
	"standing",
	"dying",
	"dead",
	"panic"
]

# number of states that can be randomly chosen
const NUM_NORMAL_STATES = 3

var sprite_node
var animation_timer

func _ready():
	set_fixed_process(true)
	roll_states = true
	_roll_new_state()
	sprite_node = get_node("Sprite")
	animation_timer = 0
	
func _fixed_process(delta):
	state_timer -= delta
	if state_timer <= 0 and roll_states:
		_roll_new_state()
	
	animation_timer += delta
	if animation_timer >= 0.8:
		animation_timer = 0
		if current_state == "dying":
			current_state = "dead"
	
	if current_state == "moving_right":
		if !get_node("look_right").is_colliding():
			translate(Vector2(50 * delta, 0))
			# animation
			sprite_node.set_flip_h(true)
			sprite_node.set_frame(int(animation_timer / 0.2))
	elif current_state == "moving_left":
		if !get_node("look_left").is_colliding():
			# move
			translate(Vector2(-50 * delta, 0))
			# animation
			sprite_node.set_flip_h(false)
			sprite_node.set_frame(int(animation_timer / 0.2))
	elif current_state == "dying":
		# animation (bad hack! dying only has 3 frames, therefore 4 + 2 is max here)
		sprite_node.set_frame(8 + min(int(animation_timer / 0.2), 2))
	elif current_state == "panic":
		# animation
		sprite_node.set_frame(4 + int(animation_timer / 0.2))
		# todo: move around randomly
	elif current_state == "dead":
		sprite_node.set_frame(10)
		
	else:
		# standing
		sprite_node.set_frame(0)

func _roll_new_state():
	state_timer = rand_range(1.5, 4.0)
	current_state = STATE[randi() % NUM_NORMAL_STATES]

func kill():
	roll_states = false
	current_state = "dying"
	# dying only has 3 frames
	animation_timer = 0.2
	get_node("CollisionShape2D").remove_and_skip()