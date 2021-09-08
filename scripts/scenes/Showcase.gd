extends Control

func setup():
	for child in $scroll/display.get_children():
		child.queue_free()
	
	for toy in TeamHandler.stored_toys:
		var new_toy_stats = toy.duplicate()
		
		var new_toy_combatant = load("res://scenes/entities/ToyCombatant.tscn").instance()
		new_toy_combatant.set_toy(new_toy_stats)
		new_toy_combatant.scale = Vector2(.35, .35)
		
		var new_vbox = VBoxContainer.new()
		new_vbox.rect_min_size.x = 180
		
		new_vbox.connect("gui_input", self, "check_click_on_toy", [new_toy_stats])
		
		var new_box = Control.new()
		new_box.rect_min_size.y = 180
		new_vbox.add_child(new_box)
		new_box.add_child(new_toy_combatant)
		new_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
		new_toy_combatant.position = Vector2(90, 90)
		
		var new_name = Label.new()
		new_name.text = new_toy_stats.toy_name
		new_name.align = Label.ALIGN_CENTER
		new_vbox.add_child(new_name)
		
		$scroll/display.add_child(new_vbox)
		
		new_name.rect_global_position = new_toy_combatant.global_position - Vector2(new_name.rect_size.x / 2.0, -30)
		
		$Selected.text = TeamHandler.current_team[0].toy_name
		

func check_click_on_toy(event, toy):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			select_toy(toy)

func select_toy(toy):
	$Selected.text = toy.toy_name
	TeamHandler.set_current_toy(toy)
