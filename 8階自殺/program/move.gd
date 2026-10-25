extends Node2D

@onready var layer = $CanvasLayer3
@onready var control = $CanvasLayer3/Control

func _ready():
	get_tree().paused = true
	control.finished.connect(_on_opening_finished, CONNECT_ONE_SHOT)
	layer.tree_exited.connect(_on_layer_removed)


func _on_opening_finished():
	get_tree().paused = false


func _on_layer_removed():
	get_tree().paused = false
