extends Node

# General signals

signal start_screenshake(force, duration, deceleration)
signal create_object(effect_instance)

signal player_health_changed(new_value)
signal enemy_health_changed(new_value)

signal show_message(message_list, event)
signal lock_player()
signal unlock_player()

signal start_battle(enemy_team)
signal end_battle()

signal shake_screen(force)

signal update_status(combatant, effect)
signal update_buff(combatant, effect)

signal play_hover_sound()
