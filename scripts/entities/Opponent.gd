extends KinematicBody2D

export (Array) var message_list_before_battle = []

export (Array) var team = []

var player = null
var is_player_nearby = false

var colliding_pushbox = []

func _ready():
	pass

func _process(delta):
	
	var push_force = Vector2.ZERO
	for pushbox in colliding_pushbox:
		push_force += (global_position - pushbox.global_position).normalized() * 10
	
	move_and_slide(push_force)

func _on_Pushbox_area_entered(area):
	if area.is_in_group("Pushbox"):
		colliding_pushbox.append(area)

func _on_Pushbox_area_exited(area):
	if area.is_in_group("Pushbox") && colliding_pushbox.has(area):
		colliding_pushbox.erase(area)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		is_player_nearby = true

func _on_Area2D_body_exited(body):
	if body == player:
		is_player_nearby = false
		player = null

func _on_TextureButton_pressed():
	if is_player_nearby:
		if !player.is_paused:
			
			var battle_event = {
				type = "battle",
				team = team.duplicate()
			}
			TeamHandler.current_opponent = self
			EventBus.emit_signal("show_message", message_list_before_battle.duplicate(), battle_event)
