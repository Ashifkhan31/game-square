extends Area2D

class_name bullet

var speed:int = 9
var dir:Vector2= Vector2.ZERO

var raycast:RayCast2D
var timer:Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 1.5
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", self_destruct)
	add_child(timer)

func _physics_process(delta: float) -> void:
	global_position += dir * speed

func _on_area_entered(area: Area2D) -> void:
	hit(area)

func _on_body_entered(body: Node2D) -> void:
	hit(body)

func hit(node :Node2D):
	if node.has_method("bullet_hit"):
		node.bullet_hit()
	queue_free()

func self_destruct():
	queue_free()
