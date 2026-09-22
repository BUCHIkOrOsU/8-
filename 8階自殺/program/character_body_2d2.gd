extends CharacterBody2D
var speed = 700
var direction = "migi" 
var friction = 1500
@onready var camera: Camera2D = $Camera2D


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:


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
