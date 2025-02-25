tool
extends AnimationPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for anim in get_animation_list():
		for each in get_animation_list():
			if each != anim and each != "Climb":
				if each.find("Hurt") != -1:
					set_blend_time(anim, each, 0.05)
				else:
					set_blend_time(anim, each, 0.2)
			else:
				set_blend_time(anim, each, 0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
