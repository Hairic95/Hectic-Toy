extends Node2D

var status_icon_reference = load("res://scenes/ui/StatusIcon.tscn")

# Battle

var current_player_toy = null
var current_enemy_toy = null

# SHIVERING VARIABLES
# Insert here the code for the shiver from Ash K Library


onready var target_camera = $Camera2D

func _ready():
	EventBus.connect("create_object", self, "create_object")
	EventBus.connect("player_health_changed", self, "player_health_changed")
	EventBus.connect("enemy_health_changed", self, "enemy_health_changed")
	EventBus.connect("shake_screen", self, "shiver_at_amplitude")
	EventBus.connect("update_status", self, "update_status")
	
	initialize_toys()
	
	yield(get_tree(), "idle_frame")
	
	start_battle_tween()
	
	yield(get_tree().create_timer(.4), "timeout")
	show_battle_message("TOY BATTLE BEGINNING!")
	
	yield(get_tree().create_timer(2.0), "timeout")
	show_actions()

func _process(delta):
	
	var total_offset = Vector2.ZERO
	
	# SHIVERING SECTION
	# Insert here the code for the shiver from Ash K Library
	
	if target_camera != null:
		target_camera.position = total_offset



#==================================================
# Screenshake
func shiver_at_amplitude(amplitude):
	# Insert here the code for the shiver from Ash K Library
	pass

#==================================================
# Battle message animation

func show_battle_message(text):
	$UI/BattleMessage.text = text
	
	$UI/BattleMessage/BattleMessageTween.interpolate_property($UI/BattleMessage, "rect_position", 
			Vector2(0, -20), 
			Vector2(0, get_viewport().size.y / 3.0), .4)
	$UI/BattleMessage/BattleMessageTween.start()

func _on_BattleMessageTween_tween_all_completed():
	if $UI/BattleMessage.rect_position.y <= get_viewport().size.y:
		
		yield(get_tree().create_timer(1.2), "timeout")
		
		$UI/BattleMessage/BattleMessageTween.interpolate_property($UI/BattleMessage, "rect_position", 
				$UI/BattleMessage.rect_position, Vector2(0, get_viewport().size.y + 20), .6)
		$UI/BattleMessage/BattleMessageTween.start()
	else:
		#do action
		pass


#==================================================
# Intro and toy change animations

func start_battle_tween():
	
	player_in_scene()
	enemy_in_scene()

func player_in_scene():
	$Combatants/Player/Tween.interpolate_property($Combatants/Player, "global_position", 
			Vector2(-100, get_viewport().size.y / 2.0 + 20), 
			Vector2(120, get_viewport().size.y / 2.0 + 20), .4)
	$Combatants/Player/Tween.interpolate_property($UI/PlayerHealthBar, "rect_global_position", 
			Vector2(30, -60), 
			Vector2(30, 20), .4)
	$Combatants/Player/Tween.interpolate_property($UI/PlayerName, "rect_global_position", 
			Vector2($UI/PlayerName.rect_position.x, get_viewport().size.y + 60), 
			Vector2($UI/PlayerName.rect_position.x, get_viewport().size.y - 40), .4)
	$Combatants/Player/Tween.start()

func enemy_in_scene():
	$Combatants/Enemy/Tween.interpolate_property($Combatants/Enemy, "global_position", 
			Vector2(get_viewport().size.x + 100, get_viewport().size.y / 2.0 + 20), 
			Vector2(get_viewport().size.x - 120, get_viewport().size.y / 2.0 + 20), .4)
	$Combatants/Enemy/Tween.interpolate_property($UI/EnemyHealthBar, "rect_global_position", 
			Vector2(get_viewport().size.x - 30, -60), 
			Vector2(get_viewport().size.x - 30, 20), .4)
	$Combatants/Enemy/Tween.interpolate_property($UI/EnemyName, "rect_global_position", 
			Vector2($UI/EnemyName.rect_position.x, get_viewport().size.y + 60), 
			Vector2($UI/EnemyName.rect_position.x, get_viewport().size.y - 40), .4)
	$Combatants/Enemy/Tween.start()


func player_out_of_scene():
	$Combatants/Player/Tween.interpolate_property($Combatants/Player, "global_position", 
			$Combatants/Player.global_position, 
			Vector2(-100, get_viewport().size.y / 2.0 + 20), .4)
	$Combatants/Player/Tween.interpolate_property($UI/PlayerHealthBar, "rect_global_position", 
			$UI/PlayerHealthBar.rect_global_position, 
			Vector2(30, -60), .4)
	$Combatants/Player/Tween.interpolate_property($UI/PlayerName, "rect_global_position", 
			$UI/PlayerName.rect_global_position, 
			Vector2($UI/PlayerName.rect_position.x, get_viewport().size.y + 60), .4)
	$Combatants/Player/Tween.start()
	
	for icon in $UI/PlayerHealthBar/Status.get_children():
		icon.queue_free()

func enemy_out_of_scene():
	$Combatants/Enemy/Tween.interpolate_property($Combatants/Enemy, "global_position", 
			$Combatants/Enemy.global_position, 
			Vector2(get_viewport().size.x + 100, get_viewport().size.y / 2.0 + 20), .4)
	$Combatants/Enemy/Tween.interpolate_property($UI/EnemyHealthBar, "rect_global_position", 
			$UI/EnemyHealthBar.rect_global_position, 
			Vector2(get_viewport().size.x - 30, -60), .4)
	$Combatants/Enemy/Tween.interpolate_property($UI/EnemyName, "rect_global_position", 
			$UI/EnemyName.rect_global_position,
			Vector2($UI/EnemyName.rect_position.x, get_viewport().size.y + 60), .4)
	$Combatants/Enemy/Tween.start()
	for icon in $UI/EnemyHealthBar/Status.get_children():
		icon.queue_free()


#==================================================
# General UI

func player_health_changed(new_value):
	$UI/PlayerHealthBar/HealthBar.change_value(new_value)

func enemy_health_changed(new_value):
	$UI/EnemyHealthBar/HealthBar.change_value(new_value)

func _on_PlayerHealthBar_value_changed(value):
	$UI/PlayerHealthBar/Value.text = str(value)

func _on_EnemyHealthBar_value_changed(value):
	$UI/EnemyHealthBar/Value.text = str(value)

func update_status(combatant, status):
	
	if combatant.is_ko:
		return
	
	if combatant.is_player:
		for icon in $UI/PlayerHealthBar/Status.get_children():
			if icon.code == status.status:
				if status.duration <= 0:
					icon.queue_free()
				else:
					icon.change_duration(status.duration)
				return
	else:
		for icon in $UI/EnemyHealthBar/Status.get_children():
			if icon.code == status.status:
				if status.duration <= 0:
					icon.queue_free()
				else:
					icon.change_duration(status.duration)
				return
	
	var new_status_icon = status_icon_reference.instance()
	new_status_icon.init(status.status, status.icon, status.duration, status.status + " - " + status.description)
	
	if combatant.is_player:
		$UI/PlayerHealthBar/Status.add_child(new_status_icon)
	else:
		$UI/EnemyHealthBar/Status.add_child(new_status_icon)
	
	yield(get_tree().create_timer(1.6), "timeout")


func play_hover_sound():
	EventBus.emit_signal("play_hover_sound")






#==================================================
# Spawn

func create_object(effect : Node):
	$Effects.add_child(effect)


#==================================================
# Battle

func initialize_toys():
	
	if TeamHandler.current_enemy_team.size() > 0:
		current_enemy_toy = TeamHandler.current_enemy_team[0] as ToyStats
	else:
		EventBus.emit_signal("end_battle")
	
	if TeamHandler.current_team.size() > 0:
		current_player_toy = TeamHandler.current_team[0] as ToyStats
	else:
		EventBus.emit_signal("end_battle")
	
	change_player_toy(current_player_toy)
	change_enemy_toy(current_enemy_toy)
	
	$UI/PlayerHealthBar/HealthBar.max_value = current_player_toy.max_hit_points
	$UI/PlayerHealthBar/HealthBar.value = current_player_toy.hit_points
	
	$UI/EnemyHealthBar/HealthBar.max_value = current_enemy_toy.max_hit_points
	$UI/EnemyHealthBar/HealthBar.value = current_enemy_toy.hit_points
	$UI/EnemyHealthBar/HealthBar.is_enemy = true

func change_player_toy(toy_stats : ToyStats):
	$Combatants/Player.set_toy(toy_stats)
	$UI/PlayerName.text = toy_stats.toy_name

func change_enemy_toy(toy_stats : ToyStats):
	$Combatants/Enemy.set_toy(toy_stats)
	$UI/EnemyName.text = toy_stats.toy_name

func show_actions():
	
	var available_actions = $Combatants/Player.get_actions()
	
	var is_player_out_of_action = true
	for action in available_actions:
		if action.current_uses > 0:
			is_player_out_of_action = false
	
	if is_player_out_of_action:
		show_battle_message("The player is out of action.")
		yield(get_tree().create_timer(1.6), "timeout")
		$Combatants/Player.hit(999)
	
	var enemy_actions = $Combatants/Enemy.get_actions()
	
	var is_enemy_out_of_action = true
	for action in enemy_actions:
		if action.current_uses > 0:
			is_enemy_out_of_action = false
	
	if is_enemy_out_of_action:
		show_battle_message("The enemy is out of action.")
		yield(get_tree().create_timer(1.6), "timeout")
		$Combatants/Enemy.hit(999)
	
	if is_battle_over():
		return
	
	for action in available_actions:
		var new_button = Button.new()
		new_button.text = str(action.action_name, " (PWR: ", action.power, ") ", action.current_uses, "/", action.max_uses)
		new_button.connect("pressed", self, "action_selected", [action])
		new_button.connect("mouse_entered", self, "play_hover_sound")
		new_button.hint_tooltip = action.description
		if action.current_uses <= 0:
			new_button.disabled = true
		$UI/Actions.add_child(new_button)
	
	yield(get_tree().create_timer(.01), "timeout")
	
	$UI/ActionsTween.interpolate_property($UI/Actions, "rect_position", 
			Vector2((get_viewport().size.x - $UI/Actions.rect_size.x) / 2.0, -100),
			Vector2((get_viewport().size.x - $UI/Actions.rect_size.x) / 2.0, 
					get_viewport().size.y - 100), .5)
	$UI/ActionsTween.start()

func action_selected(player_action):
	
	for button in $UI/Actions.get_children():
		button.disabled = true
	
	$UI/ActionsTween.interpolate_property($UI/Actions, "rect_position", 
			$UI/Actions.rect_position,
			Vector2((get_viewport().size.x - $UI/Actions.rect_size.x) / 2.0, 
					600), .7)
	$UI/ActionsTween.start()
	
	# AI
	var enemy_actions = $Combatants/Enemy.get_actions()
	
	var available_enemy_actions = []
	
	for action in enemy_actions:
		if action.current_uses > 0:
			available_enemy_actions.append(action)
	var enemy_action
	if available_enemy_actions.size() != 0:
		enemy_action = available_enemy_actions[randi()% available_enemy_actions.size()]
	
	yield(get_tree().create_timer(.8), "timeout")
	
	for button in $UI/Actions.get_children():
		button.queue_free()
	
	# initiative
	var turn_order = []
	
	turn_order.append($Combatants/Player)
	turn_order.append($Combatants/Enemy)
	
	if $Combatants/Enemy.get_speed() > $Combatants/Player.get_speed() && !$Combatants/Enemy.has_status("Stunned"):
		var temp = turn_order[0]
		turn_order[0] = turn_order[1]
		turn_order[1] = temp
	elif $Combatants/Player.has_status("Stunned") && !$Combatants/Enemy.has_status("Stunned"):
		var temp = turn_order[0]
		turn_order[0] = turn_order[1]
		turn_order[1] = temp
	elif !$Combatants/Enemy.has_status("Stunned"):
		if randi()%2 == 0:
			var temp = turn_order[0]
			turn_order[0] = turn_order[1]
			turn_order[1] = temp
	
	for combatant in turn_order:
		
		var target_combatant = null
		var action = null
		var self_combatant = null
		
		if combatant.is_player:
			target_combatant = $Combatants/Enemy
			action = player_action
			self_combatant = $Combatants/Player
			show_battle_message(combatant.get_toy_name() + " uses " + player_action.action_name)
		else:
			target_combatant = $Combatants/Player
			action = enemy_action
			self_combatant = $Combatants/Enemy
			show_battle_message("Enemy " + combatant.get_toy_name() + " uses " + enemy_action.action_name)
		
		action.current_uses = max(player_action.current_uses - 1, 0)
		
		yield(get_tree().create_timer(1.6), "timeout")
		
		if action.action_type != "status":
			var bonus_damage = 0
			if self_combatant.has_status("Stronger"):
				bonus_damage = 1
			target_combatant.deal_damage(action.power, action.action_type, bonus_damage)
		
		yield(get_tree().create_timer(.2 * action.power + .5), "timeout")
		
		if target_combatant.is_ko:
			if target_combatant.is_player:
				player_out_of_scene()
			else:
				enemy_out_of_scene()
		
		if !target_combatant.is_ko:
			for effect in action.effects:
				target_combatant.add_effect(effect)
				yield(get_tree().create_timer(1.6), "timeout")
		for effect in action.self_effects:
			self_combatant.add_effect(effect)
			yield(get_tree().create_timer(1.6), "timeout")
		
		# check if combatants are defeated after effects
		
		if target_combatant.is_ko:
			if target_combatant.is_player:
				player_out_of_scene()
			else:
				enemy_out_of_scene()
		
		if self_combatant.is_ko:
			if self_combatant.is_player:
				player_out_of_scene()
			else:
				enemy_out_of_scene()
		
		if is_battle_over():
			yield(get_tree().create_timer(2.5), "timeout")
			EventBus.emit_signal("end_battle")
			return
	
	for combatant in turn_order:
		combatant.tick_effects()
		
		if combatant.is_ko:
			if combatant.is_player:
				player_out_of_scene()
			else:
				enemy_out_of_scene()
	
	if is_battle_over():
		yield(get_tree().create_timer(2.5), "timeout")
		EventBus.emit_signal("end_battle")
	else:
		show_actions()

func is_enemy_defeated():
	var result = true
	
	for toy in TeamHandler.current_enemy_team:
		if toy.hit_points > 0:
			result = false
	return result

func is_player_defeated():
	var result = true
	for toy in TeamHandler.current_team:
		if toy.hit_points > 0:
			result = false
	return result

func is_battle_over():
	if is_enemy_defeated() && is_player_defeated():
		current_enemy_toy.fully_heal()
		show_battle_message("oh wow a tie!")
		return true
	elif is_enemy_defeated():
		TeamHandler.add_toy_from_resource(TeamHandler.current_enemy_team[0])
		
		if TeamHandler.current_opponent != null:
			TeamHandler.current_opponent.queue_free()
			TeamHandler.current_opponent = null
		
		show_battle_message("You won this battle!")
		return true
	elif is_player_defeated():
		current_enemy_toy.fully_heal()
		show_battle_message("You lost lmao")
		return true
	return false
