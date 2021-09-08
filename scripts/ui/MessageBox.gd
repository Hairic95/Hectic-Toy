extends CanvasLayer

var message_list = []

var hidden_pos = Vector2(0, 300)
var shown_pos = Vector2(0, 226)

var current_event = null

func _ready():
	$Textbox.rect_position = hidden_pos
	EventBus.connect("show_message", self, "show_message")

func show_message(new_message_list, event = null):
	
	EventBus.emit_signal("lock_player")
	
	message_list = new_message_list
	current_event = event
	
	get_next_message()
	
	$Textbox/Tween.interpolate_property($Textbox, "rect_position", $Textbox.rect_position, shown_pos, .1)
	$Textbox/Tween.start()

func get_next_message():
	EventBus.emit_signal("play_hover_sound")
	if message_list.size() == 0:
		
		if current_event != null:
			match (current_event.type):
				"battle":
					EventBus.emit_signal("start_battle", current_event.team)
		else:
			EventBus.emit_signal("unlock_player")
		$Textbox.rect_position = hidden_pos
	else:
		$Textbox/Text.text = message_list.pop_front()


func _on_Button_pressed():
	get_next_message()
