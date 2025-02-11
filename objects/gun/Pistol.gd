extends Node2D


var ammo_in_magazine = 15
onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func _physics_process(delta):
#	if Input.is_action_just_pressed("shoot"):
#		shoot()
#	if Input.is_action_just_pressed("reload"):
#		reload()

func shoot():
	if !animation_player.is_playing() and ammo_in_magazine != 0:
		ammo_in_magazine -= 1
		animation_player.play("Shoot")

func reload():
	if !animation_player.is_playing() and ammo_in_magazine < 15:
		animation_player.play("Reload")

func reload_finished():
	ammo_in_magazine = 15
