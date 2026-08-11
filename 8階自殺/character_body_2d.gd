extends CharacterBody2D
var speed = 700
var direction = "migi" #方向
var friction = 1500
@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.make_current()
	#camera.zoom = Vector2(1.5, 1.5)
	camera.position_smoothing_enabled = false
	camera.offset = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		$"first_person".play("migi_muki")
		direction="migi" #向いている方向
	
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		$"first_person".play("hidari_muki")
		direction="hidari"
	
	else :
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		if velocity.x == 0:
			if direction == "migi":
				$"first_person".play("tomari_migi_muki")	
			elif direction == "hidari":
				$"first_person".play("tomari_hidari_muki")



	move_and_slide()
