extends KinematicBody2D

var position_datalist = []
var index_count = 0
var latest_index = 0
var move_vec = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if !Input.is_action_pressed("reverse_time"):
		$CanvasLayer/ColorRect.material.set_shader_param("invert", false)
		move_vec = move_and_slide(move_vec, Vector2.UP)
		move_vec.y += 10
		var target_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		if is_on_floor():
			move_vec.x = clamp(move_vec.x + target_dir * 16, -256, 256)
			if target_dir == 0:
				move_vec.x = lerp(move_vec.x, 0, 0.2)
		elif target_dir != 0:
			move_vec.x = clamp(move_vec.x + target_dir * 16, -256, 256)
		if Input.is_action_just_pressed("jump") and is_on_floor():
			move_vec.y = -512
		if position_datalist.size() < 500:
			position_datalist.append([position, move_vec])
		else:
			position_datalist[index_count] = [position, move_vec]
		latest_index = index_count
		index_count += 1
	else:
		$CanvasLayer/ColorRect.material.set_shader_param("invert", true)
		if position_datalist.size() > 0:
			var prev_condition = position_datalist.pop_back()
			position = prev_condition[0]
			move_vec = prev_condition[1]
