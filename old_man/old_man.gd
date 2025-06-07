extends Area2D

var interactable

@export var filepath:String
var Jsontext

func _ready():
	var file = FileAccess.open(filepath,FileAccess.READ)
	Jsontext = file.get_as_text()

func interact(player: CharacterBody2D):
	if player.shooting_bool == false:
		player.shooting_bool = true
		$"CanvasLayer/dialog-box".load_dialog(Jsontext)
		$"CanvasLayer/dialog-box".play_dialog()
		await $"CanvasLayer/dialog-box".finished
	player.player_restrict = false
