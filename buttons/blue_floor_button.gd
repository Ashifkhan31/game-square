extends Area2D

@onready var sprite = $Sprite2D
var pressing_objects:Array

signal pressed
signal unpressed

func _on_body_entered(body: Node2D) -> void:
	var body_script = body.get_script()
	if body_script != null:
		if body_script.get_global_name() == "player":
			pressed.emit()
			pressing_objects.append(body)
			sprite.modulate = Color(0.7,0.7,0.7,1)

func _on_body_exited(body: Node2D) -> void:
	var body_script = body.get_script()
	if body_script != null:
		if body_script.get_global_name() == "player":
			pressing_objects.erase(body)
			if pressing_objects.is_empty():
				unpressed.emit()
				sprite.modulate = Color(1,1,1,1)


func _on_area_entered(area: Area2D) -> void:
	var area_script = area.get_script()
	if area_script != null:
		if area_script.get_global_name() == "brick":
			pressed.emit()
			pressing_objects.append(area)
			sprite.modulate = Color(0.7,0.7,0.7,1)


func _on_area_exited(area: Area2D) -> void:
	var area_script = area.get_script()
	if area_script != null:
		if area_script.get_global_name() == "brick":
			pressing_objects.erase(area)
			if pressing_objects.is_empty():
				unpressed.emit()
				sprite.modulate = Color(1,1,1,1)
