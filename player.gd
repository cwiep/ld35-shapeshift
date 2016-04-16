
extends Area2D

var player_image
var anim_node

var can_use_stairs
var is_using_stairs
var stairs_move_target
var current_stairs

const TARGETS = {
	"book": 0
}

var current_target

func _ready():
	set_fixed_process(true)
	player_image = get_node("Sprite")
	anim_node = get_node("Sprite/walk_anim")
	can_use_stairs = false
	is_using_stairs = false
	current_target = TARGETS["book"]
	
func _fixed_process(delta):
	if is_using_stairs:
		# move player toward target
		set_pos(Vector2(lerp(get_pos().x, stairs_move_target.x, 0.05), lerp(get_pos().y, stairs_move_target.y, 0.05)))
		if get_pos().distance_to(stairs_move_target) < 3:
			set_pos(stairs_move_target)
			is_using_stairs = false
			stairs_move_target = current_stairs.get_stairs_target(get_pos())
	else:
		# otherwise allow normal motion
		if Input.is_action_pressed("ui_left") and !get_node("look_left").is_colliding():
			translate(Vector2(-400 * delta, 0))
			#anim_node.play("walk")
		elif Input.is_action_pressed("ui_right") and !get_node("look_right").is_colliding():
			translate(Vector2(400 * delta, 0))
			#anim_node.play("walk")
		if Input.is_action_pressed("ui_accept") and can_use_stairs:
			is_using_stairs = true
		
func _on_player_area_enter( area ):
	if area.is_in_group("stairs"):
		can_use_stairs = true
		current_stairs = area
		stairs_move_target = area.get_stairs_target(get_pos())
	elif area.is_in_group("book") and current_target == TARGETS["book"]:
		print("can collect")

func _on_player_area_exit( area ):
	can_use_stairs = false
