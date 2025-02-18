extends Node2D

export var health = 30
signal died()

func _on_KinematicBody2D_received_damage(damage):
	health -= damage
	if health <= 0:
		emit_signal("died")
