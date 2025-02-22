extends Node2D

enum Equip{None, Pistol, AssaultRifle}
export (Equip) var equipped = Equip.None setget set_equipped
onready var weapon = [0, $Pistol, $AssaultRifle]

func set_equipped(new_equipped):
	equipped = new_equipped
	match equipped:
		Equip.AssaultRifle:
			weapon[Equip.AssaultRifle].visible = true
			weapon[Equip.Pistol].visible = false
		Equip.Pistol:
			weapon[Equip.AssaultRifle].visible = false
			weapon[Equip.Pistol].visible = true
		Equip.None:
			weapon[Equip.AssaultRifle].visible = false
			weapon[Equip.Pistol].visible = false

func get_equipped_name():
	return weapon[equipped].name

func shoot():
	weapon[equipped].shoot()

func reload():
	return weapon[equipped].reload()
