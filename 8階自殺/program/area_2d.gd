extends Area2D

var is_choosing = false
var choice_index = 0
var choices = ["はい", "いいえ"]
var player: Node = null

@export var next_scene: String

var choice2_ui: Control
var question2_label: Label
var choice2_labels: Array = []


func _ready() -> void:
	var layer = get_parent().get_node("CanvasLayer2")
	choice2_ui = layer.get_node("choiceUI")
	question2_label = choice2_ui.get_node("VBoxContainer/PanelContainer/questionlabel2")
	choice2_labels = [
		choice2_ui.get_node("VBoxContainer/HBoxContainer/PanelContainer/yeslabel2"),
		choice2_ui.get_node("VBoxContainer/HBoxContainer/PanelContainer2/nolabel2")
	]
	choice2_ui.visible = false
	body_entered.connect(_on_body_entered)


func _on_body_entered(body) -> void:
	if body.name == "CharacterBody2D" and not is_choosing:
		player = body
		open_choice()


func _physics_process(_delta: float) -> void:
	if is_choosing:
		handle_choice_input()


func open_choice() -> void:
	is_choosing = true
	choice_index = 0
	question2_label.text = "上の階に行きますか？"
	choice2_ui.visible = true
	if player:
		player.velocity = Vector2.ZERO
		player.set_physics_process(false)  
	update_choice_display()


func handle_choice_input() -> void:
	if Input.is_action_just_pressed("ui_left"):
		choice_index = (choice_index - 1 + choices.size()) % choices.size()
		update_choice_display()
	elif Input.is_action_just_pressed("ui_right"):
		choice_index = (choice_index + 1) % choices.size()
		update_choice_display()
	elif Input.is_action_just_pressed("ui_accept"):
		confirm_choice()


func update_choice_display() -> void:
	for i in choice2_labels.size():
		if i == choice_index:
			choice2_labels[i].modulate = Color(1, 1, 0)
		else:
			choice2_labels[i].modulate = Color(1, 1, 1)


func confirm_choice() -> void:
	if choice_index == 0:
		print("はいが選ばれました")
		close_choice()
		Global.fade_out()
		get_tree().change_scene_to_file(next_scene)
	else:
		print("いいえが選ばれました")
		close_choice()
		


func close_choice() -> void:
	is_choosing = false
	choice2_ui.visible = false
	if player:
		player.set_physics_process(true)  
