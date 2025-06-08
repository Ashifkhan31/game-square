extends Area2D

var interactable

@export var filepath:String
@export var dialogpath: NodePath

var dialog
var Jsontext

func _ready():
	dialog = get_node(dialogpath)
	var file = FileAccess.open(filepath,FileAccess.READ)
	Jsontext = file.get_as_text()

func interact(player: CharacterBody2D):
	if player.shooting_bool == false:
		player.shooting_bool = true
		dialog.load_dialog(Jsontext)
		dialog.play_dialog()
		await dialog.finished
	player.player_restrict = false
