extends TextureRect

var code = ""

func init(status_name, new_texture, duration, description):
	code = status_name
	texture = new_texture
	$Duration.text = str(duration)
	hint_tooltip = description

func change_duration(new_duration):
	$Duration.text = str(new_duration)


func _on_StatusIcon_mouse_entered():
	EventBus.emit_signal("play_hover_sound")
