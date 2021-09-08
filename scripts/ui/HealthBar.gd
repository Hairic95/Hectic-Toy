extends TextureProgress

export (bool) var is_enemy = false

func _ready():
	pass

func change_value(new_value):
	$HealthChanged.stop(self)
	
	$HealthChanged.interpolate_property(self, "value", value, new_value, .4)
	if !is_enemy:
		$HealthChanged.interpolate_property(self, "rect_scale", 
				Vector2(.7, .4) + Vector2(randf() - .5, randf() - .5) * .3, Vector2(.7, .4), .4, Tween.TRANS_BOUNCE)
	else:
		$HealthChanged.interpolate_property(self, "rect_scale", 
				Vector2(-.7, .4) + Vector2(randf() - .5, randf() - .5) * .3, Vector2(-.7, .4), .4, Tween.TRANS_BOUNCE)
		
	
	$HealthChanged.start()
