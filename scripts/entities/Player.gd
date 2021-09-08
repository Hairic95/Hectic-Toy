extends KinematicBody2D

var speed : float = 200.0

var colliding_pushbox : Array = []

var is_moving = false

var is_paused = false

func _ready():
	EventBus.connect("lock_player", self, "pause_player", [true])
	EventBus.connect("unlock_player", self, "pause_player", [false])
	$PlayerSprite/AnimTree.active = true

func _process(delta):
	
	var movement_direction : Vector2 = Vector2.ZERO
	
	if !is_paused:
		if Input.is_action_pressed("move_up"):
			movement_direction.y += -1
			$PlayerSprite/AnimTree.set("parameters/Direction/blend_amount", 1)
		if Input.is_action_pressed("move_down"):
			movement_direction.y += 1
			$PlayerSprite/AnimTree.set("parameters/Direction/blend_amount", 0)
		if Input.is_action_pressed("move_left"):
			movement_direction.x += -1
		if Input.is_action_pressed("move_right"):
			movement_direction.x += 1
	
	if movement_direction != Vector2.ZERO:
		is_moving = true
		$PlayerSprite/AnimTree.set("parameters/Down_State/blend_amount", 1)
		$PlayerSprite/AnimTree.set("parameters/Up_State/blend_amount", 1)
	else:
		is_moving = false
		$PlayerSprite/AnimTree.set("parameters/Down_State/blend_amount", 0)
		$PlayerSprite/AnimTree.set("parameters/Up_State/blend_amount", 0)
	
	var push_force = Vector2.ZERO
	for pushbox in colliding_pushbox:
		push_force += (global_position - pushbox.global_position).normalized() * 10
	
	move_and_slide(movement_direction.normalized() * speed + push_force)
	
	movement_direction = Vector2.ZERO

func _on_Pushbox_area_entered(area):
	if area.is_in_group("Pushbox"):
		colliding_pushbox.append(area)

func _on_Pushbox_area_exited(area):
	if area.is_in_group("Pushbox") && colliding_pushbox.has(area):
		colliding_pushbox.erase(area)

func pause_player(value):
	is_paused = value

func close_camera():
	$Camera2D.current = false

func open_camera():
	$Camera2D.current = true
