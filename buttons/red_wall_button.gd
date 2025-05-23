extends Area2D

var pressed = false

func _on_area_entered(area: Area2D) -> void:
	var area_script = area.get_script()
	if area_script != null:
		if area_script.get_global_name() == "bullet":
			if not pressed:
				$AnimatedSprite2D.play("pressed")
			pressed = true


func _on_body_entered(body: Node2D) -> void:
	var body_script = body.get_script()
	if body_script != null:
		if body_script.get_global_name() == "player":
			if not pressed:
				$AnimatedSprite2D.play("pressed")
			pressed = true
