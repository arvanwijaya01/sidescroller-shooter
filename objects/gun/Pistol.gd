extends Node2D

export var max_ammo = 15
var ammo_in_magazine = 15
onready var animation_player = $AnimationPlayer
onready var raycast = $RayCast2D
onready var line = $RayCast2D/Node/Line2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot():
	if !animation_player.is_playing() and ammo_in_magazine != 0:
		line.points[1] = Vector2(((raycast.get_collision_point() - raycast.global_position).length()) if raycast.is_colliding() else 1000.0, 0.0)
		ammo_in_magazine -= 1
		line.rotation = rotation
		line.position = raycast.global_position
		line.scale = scale
		animation_player.play("Shoot")
		var viewport_size = get_viewport_rect().size
		var recoil_position = Vector2(rand_range(-5.0, 5.0), rand_range(-10.0, -5.0))
		recoil_position = get_viewport().get_mouse_position() + recoil_position.rotated(rotation)
		recoil_position = Vector2(clamp(recoil_position.x, 0.0, viewport_size.x), clamp(recoil_position.y, 0.0, viewport_size.y))
		get_viewport().warp_mouse(recoil_position)

func reload():
	if !animation_player.is_playing() and ammo_in_magazine < max_ammo:
		animation_player.play("Reload")
		return true
	return false

func reload_finished():
	ammo_in_magazine = max_ammo
