extends CharacterBody2D


const SPEED = 120.0


func _physics_process(delta: float) -> void:
	var dir_y := Input.get_axis("ui_up", "ui_down")
	if dir_y:
		velocity.y = dir_y * SPEED
	else: 
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	var dir_x := Input.get_axis("ui_left", "ui_right")
	if dir_x:
		velocity.x = dir_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
