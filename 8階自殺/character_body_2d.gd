extends CharacterBody2D
var speed = 700
var direction = "migi" 
var friction = 1500
@onready var camera: Camera2D = $Camera2D

var is_choosing = false
var choice_index = 0            
var choices = ["はい", "いいえ"]

@onready var choice_ui: Control = $"../CanvasLayer/choiceUI"
@onready var question_label: Label = $"../CanvasLayer/choiceUI/VBoxContainer/PanelContainer/questionlabel"
@onready var choice_labels: Array = [
	$"../CanvasLayer/choiceUI/VBoxContainer/HBoxContainer/PanelContainer/yeslabel",
	$"../CanvasLayer/choiceUI/VBoxContainer/HBoxContainer/PanelContainer2/nolabel"
]

func _ready() -> void:
	camera.make_current()
	camera.position_smoothing_enabled = false
	camera.offset = Vector2.ZERO
	choice_ui.visible = false

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_down") and not is_choosing:
		open_choice()
		return

	if is_choosing:
		handle_choice_input()
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		$"first_person".play("migi_muki")
		direction = "migi"

	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		$"first_person".play("hidari_muki")
		direction = "hidari"

	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		if velocity.x == 0:
			if direction == "migi":
				$"first_person".play("tomari_migi_muki")
			elif direction == "hidari":
				$"first_person".play("tomari_hidari_muki")

	move_and_slide()


func open_choice() -> void:
	is_choosing = true
	choice_index = 0
	question_label.text = "飛び降りますか？"
	choice_ui.visible = true
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
	for i in choice_labels.size():
		if i == choice_index:
			choice_labels[i].modulate = Color(1, 1, 0)
		else:
			choice_labels[i].modulate = Color(1, 1, 1)


func confirm_choice() -> void:
	if choice_index == 0:
		print("はいが選ばれました")
	else:
		print("いいえが選ばれました")

	close_choice()


func close_choice() -> void:
	is_choosing = false
	choice_ui.visible = false
