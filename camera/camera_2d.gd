extends Camera2D

func make_camera_current(body: Node2D) -> void:
	var body_script = body.get_script()
	if body_script != null:
		if body_script.get_global_name() == "player":
			make_current()
