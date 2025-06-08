extends Area2D

@export var wait_time:float= 0.1
@onready var sprite = $Sprite2D
var pressing_objects:Array
var pressed = false
var timer :Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = wait_time
	timer.connect("timeout", unpress)

func _on_area_entered(area: Area2D) -> void:
	var area_script = area.get_script()
	if area_script != null:
		if area_script.get_global_name() == "key":
			if not pressed:
				pressed = true
				sprite.modulate = Color(0.7,0.7,0.7,1)
			pressing_objects.append(area)


func _on_area_exited(area: Area2D) -> void:
	var area_script = area.get_script()
	if area_script != null:
		if area_script.get_global_name() == "key":
			pressing_objects.erase(area)
			if pressing_objects.is_empty():
				if wait_time < 0.5:
					unpress()
				else:
					timer.start()

func unpress():
	if pressing_objects.is_empty():
		pressed = false
		sprite.modulate = Color(1,1,1,1)
