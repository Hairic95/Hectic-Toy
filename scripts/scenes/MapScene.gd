extends Node2D

onready var player = $YSort/Player

func _ready():
	pass

func pause_map():
	pause_mode = Node.PAUSE_MODE_STOP
	$MessageBox/Textbox.pause_mode = Node.PAUSE_MODE_STOP
	player.pause_player(true)

func hide_map():
	visible = false
	$MessageBox/Textbox.visible = false
	$MessageBox/OpenShowcase.hide()
	player.close_camera()

func resume_map():
	pause_mode = Node.PAUSE_MODE_INHERIT
	$MessageBox/Textbox.pause_mode = Node.PAUSE_MODE_INHERIT
	
	player.open_camera()
	visible = true
	$MessageBox/OpenShowcase.show()
	$MessageBox/Textbox.visible = true
	player.pause_player(false)

func show_showcase():
	$MessageBox/Showcase.setup()
	$MessageBox/Showcase/Tween.interpolate_property($MessageBox/Showcase, "rect_position", Vector2(-500, 0),
			Vector2(0, 0), .7, Tween.TRANS_ELASTIC)
	$MessageBox/Showcase/Tween.start()

func _on_OpenShowcase_pressed():
	pause_map()
	show_showcase()


func _on_TextureButton_pressed():
	resume_map()
	$MessageBox/Showcase/Tween.interpolate_property($MessageBox/Showcase, "rect_position", Vector2(0, 0),
			Vector2(-500, 0), .7, Tween.TRANS_ELASTIC)
	$MessageBox/Showcase/Tween.start()
