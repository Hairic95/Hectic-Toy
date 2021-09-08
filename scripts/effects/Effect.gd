extends Node2D


func _ready():
	$Anim.play("Effect")


func _on_Anim_animation_finished(_anim_name):
	queue_free()
