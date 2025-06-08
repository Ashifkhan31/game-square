extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		$"CanvasLayer/game-menu".visible = !$"CanvasLayer/game-menu".visible
