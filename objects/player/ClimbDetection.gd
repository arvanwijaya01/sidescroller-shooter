extends Node2D

var can_climb = false
var corner_position = Vector2.ZERO
onready var top_raycast = $TopRayCast
onready var mid_raycast = $MidRayCast
onready var bottom_raycast = $BottomRayCast

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !top_raycast.is_colliding() and bottom_raycast.is_colliding():
		corner_position = Vector2(bottom_raycast.get_collision_point().x, mid_raycast.get_collision_point().y)
		print(corner_position)
		can_climb = true
	else:
		can_climb = false
