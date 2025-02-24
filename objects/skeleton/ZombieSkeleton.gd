extends Node2D

export var health = 30
export var is_climbing = false
export var is_hurting = false
signal hurt(part)
signal died()

func _on_KinematicBody2D_received_damage(damage, part):
	health -= damage
	emit_signal("hurt", part)
	if health <= 0:
		emit_signal("died")
