extends RigidBody2D

func set_number(damage, color):
	$Label.text = str(damage)
	$Label.add_color_override("font_color", color)


func _on_Timer_timeout():
	var alpha = $Label.modulate
	alpha.a = 0
	$Tween.interpolate_property($Label, "modulate", $Label.modulate, alpha, .6)
	$CollisionShape2D.queue_free()
	$Tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
