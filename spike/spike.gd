extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("get_damage"):
		body.get_damage()
