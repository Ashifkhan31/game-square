extends Area2D


@export var wait_time:float= 0.5
var pressing_objects:Array
var timer: Timer
var pressed = false

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = wait_time
	timer.connect("timeout", unpress)

func _on_body_entered(body: Node2D) -> void:
	var body_script = body.get_script()
	if body_script != null:
		if body_script.get_global_name() == "player":
			if not pressed:
				pressed = true
				$AnimatedSprite2D.play("pressed")
			pressing_objects.append(body)

func _on_body_exited(body: Node2D) -> void:
	var body_script = body.get_script()
	if body_script != null:
		if body_script.get_global_name() == "player":
			pressing_objects.erase(body)
			if pressing_objects.is_empty():
				timer.start()


func _on_area_entered(area: Area2D) -> void:
	var area_script = area.get_script()
	if area_script != null:
		if area_script.get_global_name() == "bullet":
			if not pressed:
				pressed = true
				$AnimatedSprite2D.play("pressed")
				timer.start()

func unpress():
	if pressing_objects.is_empty():
		pressed = false
		$AnimatedSprite2D.play("unpressed")
