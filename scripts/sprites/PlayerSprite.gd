extends Node2D


func _ready():
	$AnimTree.active = true

func start_run():
	$AnimTree.set("parameters/Blend_Idle_Run/blend_amount", 1)

func start_idle():
	$AnimTree.set("parameters/Blend_Idle_Run/blend_amount", 0)
