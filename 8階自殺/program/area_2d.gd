extends Area2D

@export var next_scene: String

func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		Global.fade_out()
		get_tree().change_scene_to_file(next_scene)
