extends Area2D

@export var end: NodePath

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.queue_free()
		get_node(end).visible = true
