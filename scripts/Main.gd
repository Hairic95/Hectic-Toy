extends Node

var maps = {
	test = load("res://scenes/scenes/MapScene.tscn")
}

var battle_reference = load("res://scenes/scenes/BattleScene.tscn")

func _ready():
	randomize()
	EventBus.connect("play_hover_sound", self, "play_hover_sound")
	EventBus.connect("start_battle", self, "load_battle")
	EventBus.connect("end_battle", self, "end_battle")

func start_game():
	load_map("test")

func load_battle(enemy_team):
	
	$BGMusic.stream_paused = true
	
	fade_screen()
	yield(get_tree().create_timer(1.5), "timeout")
	
	for child in $CurrentScene.get_children():
		child.pause_map()
		child.hide_map()
	
	for child in $CurrentBattle.get_children():
		child.queue_free()
	
	var new_battle_scene = battle_reference.instance()
	TeamHandler.current_enemy_team = enemy_team
	$CurrentBattle.add_child(new_battle_scene)
	
	$BGMusicBattle.play()
	
	show_screen()

func end_battle():
	
	fade_screen()
	
	TeamHandler.heal_team()
	
	yield(get_tree().create_timer(1.5), "timeout")
	
	$BGMusicBattle.stop()
	
	for child in $CurrentBattle.get_children():
		child.queue_free()
	
	$BGMusic.stream_paused = false
	
	show_screen()
	yield(get_tree().create_timer(1.5), "timeout")
	
	
	for child in $CurrentScene.get_children():
		child.resume_map()
	

func load_map(map_id):
	
	$BGMusic.play()
	
	fade_screen()
	#yield(get_tree().create_timer(1), "timeout")
	
	for child in $CurrentScene.get_children():
		child.queue_free()
	
	if (maps.has(map_id)):
		var new_battle_scene = maps[map_id].instance()
		$CurrentScene.add_child(new_battle_scene)
	show_screen()

func fade_screen():
	$Transition/Anim.play("fade")
func show_screen():
	$Transition/Anim.play("show")


func _on_WindTimer_timeout():
	if !$Wind.playing && randi() % 5 < 3:
		$Wind.play()

func play_hover_sound():
	$HoverSound.pitch_scale = 0.7 + randf() * .5
	$HoverSound.play()


func _on_Button_pressed():
	start_game()
	$Intro.queue_free()
