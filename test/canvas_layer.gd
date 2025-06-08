extends CanvasLayer


func _on_player_child_exiting_tree(node: Node) -> void:
	$"game-menu".queue_free()
