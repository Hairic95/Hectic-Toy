extends Area2D

var player = null

func _ready():
	pass

func _process(delta):
	if player != null:
		if player.is_moving && !$Tween.is_active():
			shake()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player = body

func _on_Area2D_body_exited(body):
	if body == player:
		player = null

func shake():
	$Tween.interpolate_property($Sprite, "scale", Vector2(.1, .1) + Vector2(0, clamp(randf() * .1, .03, .06)), Vector2(.1, .1), .3, Tween.TRANS_BOUNCE)
	$Tween.start()
