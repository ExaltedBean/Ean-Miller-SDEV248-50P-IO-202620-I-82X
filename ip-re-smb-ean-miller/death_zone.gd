extends Area2D

var triggered = false

func _on_body_entered(body):

	if triggered:
		return

	if body.name != "Player":
		return

	triggered = true

	# Lose a life
	GameManager.lives -= 1

	# Lose 50% of collected DNA
	GameManager.dna_collected = floor(GameManager.dna_collected / 2.0)

	# Reset form
	GameManager.form = GameManager.Forms.SOOT

	# Game Over
	if GameManager.lives <= 0:

		GameManager.lives = 3
		GameManager.dna_collected = 0
		GameManager.form = GameManager.Forms.SOOT

		get_tree().change_scene_to_file("res://game_over.tscn")
		return

	# Restart level
	get_tree().reload_current_scene()
