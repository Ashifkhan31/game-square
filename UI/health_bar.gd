extends Control

@onready var lives: Array
var gameover: Node
var scene = preload("res://UI/gameover.tscn")

func _ready() -> void:
	lives = $HBoxContainer.get_children()


func remove_a_life(player: CharacterBody2D):
	if not lives.is_empty():
		lives.pop_back().queue_free()
	if lives.is_empty():
		player.queue_free()
		gameover.visible = true
