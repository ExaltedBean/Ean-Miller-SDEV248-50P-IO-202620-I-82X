extends Area2D

func _on_body_entered(body):

	if body.name == "Player":
		body.gain_major_powerup()
		queue_free()
