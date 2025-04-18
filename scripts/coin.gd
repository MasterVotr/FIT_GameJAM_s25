extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# Add optional checks on input if needed
	
	# Change values in player script
	body.add_coin()
	
	# do some magic with particles and what not here
	
	queue_free()		## removes the object from world
	
	
