
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

var sprite_node
var animation_timer

# ray that scans for events that cause panic
var panic_ray
const ray_left = Vector2(-100, 0)
const ray_right = Vector2(100, 0)

func _ready():
	set_fixed_process(true)
	roll_states = true
	_roll_new_state()
	animation_timer = 0
	sprite_node = get_node("Sprite")
	panic_ray = get_node("panic_ray")
	panic_ray.add_exception(self)
	
func _fixed_process(delta):
	state_timer -= delta
	if state_timer <= 0 and roll_states:
		_roll_new_state()
	
	animation_timer += delta
	if animation_timer >= 0.8:
		animation_timer = 0
		if current_state == "dying":
			current_state = "dead"
			get_node("CollisionShape2D").remove_and_skip()
	
	if current_state == "moving_right":
		if !get_node("look_right").is_colliding():
			translate(Vector2(50 * delta, 0))
			# animation
			sprite_node.set_flip_h(true)
			sprite_node.set_frame(int(animation_timer / 0.2))
			# set panic_ray direction accordingly
		panic_ray.set_cast_to(ray_right)
		_check_panic_ray()
	elif current_state == "moving_left":
		if !get_node("look_left").is_colliding():
			# move
			translate(Vector2(-50 * delta, 0))
			# animation
			sprite_node.set_flip_h(false)
			sprite_node.set_frame(int(animation_timer / 0.2))
			# set panic_ray direction accordingly
		panic_ray.set_cast_to(ray_left)
		_check_panic_ray()
	elif current_state == "dying":
		# animation (bad hack! dying only has 3 frames, therefore 8 + 2 is max here)
		sprite_node.set_frame(8 + min(int(animation_timer / 0.2), 2))
	elif current_state == "panic":
		# animation
		sprite_node.set_frame(4 + int(animation_timer / 0.2))
		roll_states = false
		if !get_node("look_left").is_colliding():
			# move
			translate(Vector2(-100 * delta, 0))
			sprite_node.set_flip_h(false)
	elif current_state == "dead":
		sprite_node.set_frame(10)
	else:
		# standing
		sprite_node.set_frame(0)
		_check_panic_ray()
		
func _check_panic_ray():
	if panic_ray.is_colliding():
		var collider = panic_ray.get_collider()
		if collider.has_method("causes_panic"):
			if collider.causes_panic():
				current_state = "panic"
				Globals.set("gameover", true)
				roll_states = false
				get_node("aah").show()

func _roll_new_state():
	state_timer = rand_range(1.5, 4.0)
	randomize()
	if current_state == "standing":
		if get_node("look_left").is_colliding():
			current_state = "moving_right"
		elif get_node("look_right").is_colliding():
			current_state = "moving_left"
		else:
			current_state = get_node("/root/global").rand_choose(["moving_left", "moving_right"])
	else:
		current_state = "standing"

func kill():
	roll_states = false
	current_state = "dying"
	# dying only has 3 frames
	animation_timer = 0
	
func causes_panic():
	return current_state == "dying" or current_state == "panic"