extends Node2D

export (bool) var is_player = true

var toy_stats = null

var is_ko = false

func _ready():
	
	randomize()
	$Sprite/Anim.play("Idle")

func set_toy(toy_stats : ToyStats):
	$Sprite.texture = toy_stats.toy_sprite
	self.toy_stats = toy_stats

func hit(damage):
	var new_slash = load("res://scenes/effects/Slash.tscn").instance()
	new_slash.global_position = global_position
	new_slash.rotation = randf() * 360
	EventBus.emit_signal("create_object", new_slash)
	
	var new_damage_effect = load("res://scenes/effects/ThrowDamage.tscn").instance()
	new_damage_effect.global_position = global_position
	
	EventBus.emit_signal("shake_screen", damage * 2.0)
	
	if is_player:
		new_damage_effect.set_number(damage, Color("2cb744"))
	else:
		new_damage_effect.set_number(damage, Color("b72c69"))
	
	var angle = clamp(randf() * PI + PI, PI / 4.0 * 5.0, PI / 4.0 * 7.0)
	new_damage_effect.apply_central_impulse(Vector2(cos(angle), sin(angle)) * 250.0)
	EventBus.emit_signal("create_object", new_damage_effect)
	
	toy_stats.hit_points = max(toy_stats.hit_points - damage, 0)
	if is_player:
		EventBus.emit_signal("player_health_changed", toy_stats.hit_points)
	else:
		EventBus.emit_signal("enemy_health_changed", toy_stats.hit_points)
	
	$Sprite/Anim.stop()
	if (randi()%2 == 0):
		$Sprite/Anim.play("Hit_01")
	else:
		$Sprite/Anim.play("Hit_02")
	
	if toy_stats.hit_points <= 0:
		is_ko = true

func _on_Anim_animation_finished(anim_name):
	if anim_name != "Idle":
		$Sprite/Anim.play("Idle")

func get_toy_name():
	return toy_stats.toy_name

func get_actions():
	return toy_stats.actions

func get_hit_points():
	return toy_stats.hit_points

func get_speed():
	return max(toy_stats.speed + toy_stats.get_buff_variation("speed"), 0)

func get_physical_defense():
	return max(toy_stats.physical_defense + toy_stats.get_buff_variation("defense"), 0)

func get_ranged_defense():
	return max(toy_stats.ranged_defense + toy_stats.get_buff_variation("defense"), 0)

func get_special_defense():
	return max(toy_stats.special_defense + toy_stats.get_buff_variation("defense"), 0)

func deal_damage(power, type, bonus_damage):
	for i in range(power):
		var damage = 0 + bonus_damage
		match(type):
			"physical":
				if i < get_physical_defense():
					damage += randi()%3 + 1
					play_hit(true)
				else:
					damage += randi()%6 + 1
					play_hit()
			"ranged":
				if i < get_ranged_defense():
					damage += randi()%3 + 1
					play_hit(true)
				else:
					damage += randi()%6 + 1
					play_hit()
			"special":
				if i < get_special_defense():
					damage += randi()%3 + 1
					play_hit(true)
				else:
					damage += randi()%6 + 1
					play_hit()
		
		hit(max(damage, 1))
		
		yield(get_tree().create_timer(.2), "timeout")

func add_effect(effect : Effect):
	if effect is EffectRecoil:
		hit(effect.amount)
		play_hit()
	elif effect is EffectStatus:
		effect = toy_stats.add_status(effect)
		EventBus.emit_signal("update_status", self, effect)
	elif effect is EffectBuff:
		toy_stats.add_buff(effect.stat, effect.value)
		EventBus.emit_signal("update_buff", self, effect)
	elif effect is EffectHeal:
		heal(effect.amount)

func tick_effects():
	for effect in toy_stats.status:
		match(effect.status):
			"Poison":
				hit(effect.duration)
				play_poison()
				if is_ko:
					return
		effect.duration -= 1
		if effect.duration <= 0:
			toy_stats.status.erase(effect)
		EventBus.emit_signal("update_status", self, effect)
		

func heal(amount):
	
	if toy_stats.has_status("Wounded"):
		amount = 0
	
	var new_damage_effect = load("res://scenes/effects/ThrowDamage.tscn").instance()
	new_damage_effect.global_position = global_position
	var angle = clamp(randf() * PI + PI, PI / 3.0 * 4.0, PI / 3.0 * 5.0)
	new_damage_effect.weight = 4.3
	new_damage_effect.apply_central_impulse(Vector2(cos(angle), sin(angle)) * 350.0)
	var amount_healed = min(toy_stats.hit_points + amount, toy_stats.max_hit_points) - toy_stats.hit_points
	new_damage_effect.set_number(amount_healed, Color("435345"))
	EventBus.emit_signal("create_object", new_damage_effect)
	
	play_heal()
	
	toy_stats.hit_points = min(toy_stats.hit_points + amount, toy_stats.max_hit_points)
	if is_player:
		EventBus.emit_signal("player_health_changed", toy_stats.hit_points)
	else:
		EventBus.emit_signal("enemy_health_changed", toy_stats.hit_points)

func has_status(status):
	return toy_stats.has_status(status)

func play_hit(blocked = false):
	$HitBlocked.stop()
	$Hit.stop()
	if blocked:
		$HitBlocked.pitch_scale = .6 + randf() * .7
		$HitBlocked.play()
	else:
		$Hit.pitch_scale = .6 + randf() * .7
		$Hit.play()

func play_heal():
	$Heal.pitch_scale = .6 + randf() * .7
	$Heal.play()

func play_poison():
	$Poison.pitch_scale = .8 + randf() * .4
	$Poison.play()
	
