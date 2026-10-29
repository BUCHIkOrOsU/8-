extends Control


var game_scene: PackedScene = preload("res://move2.1.tscn")

func load_game_scene() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _on_button_pressed():
	load_game_scene()
