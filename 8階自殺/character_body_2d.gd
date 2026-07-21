extends CharacterBody2D

var speed = 700

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		move_and_slide()
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		move_and_slide()
