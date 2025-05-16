extends Area2D

@onready var sprite = $Sprite2D

signal pressed

func _on_body_entered(body: Node2D) -> void:
	var body_script = body.get_script()
	if body_script != null:
		if body_script.get_global_name() == "player":
			pressed.emit()
			sprite.modulate = Color(0.7,0.7,0.7,1)


func _on_area_entered(area: Area2D) -> void:
	var area_script = area.get_script()
	if area_script != null:
		if area_script.get_global_name() == "brick":
			pressed.emit()
			sprite.modulate = Color(0.7,0.7,0.7,1)
