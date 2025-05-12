extends Control

@onready var text_section = $"background/HBoxContainer/MarginContainer2/text-section"
@onready var speaker_texture = $"background/HBoxContainer/MarginContainer/speaker-picture".texture

var timer: Timer = Timer.new()
var wait_time_normal = 0.03
var wait_time_fast = 0.001

var speaker_texture_dict: Dictionary
var dialog_lines_arr: Array

var lines_finished = false
var line_executing = false

func load_dialog(dialog_dict: Dictionary):
	add_child(timer)
	
	var speaker_dict = dialog_dict["speakers"]
	
	for i in speaker_dict:
		speaker_texture_dict[i] = load(speaker_dict[i])
	
	dialog_lines_arr = dialog_dict["lines"]
	
	lines_finished = false
	line_executing = false

func play_dialog():
	if text_section.get_line_count() > 4:
		print_debug("dialog box line count exceeded")
	if line_executing:
		timer.wait_time = wait_time_fast
	if not lines_finished and not line_executing:
		timer.wait_time = wait_time_normal
		visible = true
		line_executing = true
		
		var line = dialog_lines_arr.pop_front()
		
		if line != null:
			speaker_texture = speaker_texture_dict[line[0]]
			text_section.text = line[0] + ": "
			text_section.visible_characters = line[0].length() + 2
			
			for word in line[1].split(" ", false):
				text_section.text += word + " "
				for c in word + " ":
					text_section.visible_characters += 1
					timer.start()
					await timer.timeout
					timer.stop()
			
		else:
			visible = false
			lines_finished = true
		
		line_executing = false
