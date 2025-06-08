extends Control


func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("res://test/test.tscn")


func _on_button_2_button_down() -> void:
	get_tree().quit()
