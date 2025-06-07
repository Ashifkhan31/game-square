extends Control
 
var dialog_arr: Array
var enable_dialog = false

signal finished

func load_dialog(string: String):
	var data:Dictionary = JSON.parse_string(string)
	if data != null:
		dialog_arr = data["dialog"]

func play_dialog():
	enable_dialog = true
	visible = true
	if not dialog_arr.is_empty():
		$"ColorRect/HBoxContainer/MarginContainer2/text-section".text = dialog_arr.pop_front()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not dialog_arr.is_empty() and enable_dialog:
		$"ColorRect/HBoxContainer/MarginContainer2/text-section".text = dialog_arr.pop_front()
	elif event.is_action_pressed("interact") and dialog_arr.is_empty() and enable_dialog:
		visible = false
		enable_dialog = false
		finished.emit()
