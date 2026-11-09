extends Area2D

func _on_body_entered(body):

	if body.name != "Player":
		return

	if GameManager.dna_collected >= GameManager.REQUIRED_DNA:

		GameManager.lives = 3
		GameManager.dna_collected = 0
		GameManager.form = GameManager.Forms.SOOT

		get_tree().change_scene_to_file("res://victory_screen.tscn")

	else:

		GameManager.lives = 3
		GameManager.dna_collected = 0
		GameManager.form = GameManager.Forms.SOOT

		get_tree().change_scene_to_file("res://game_over.tscn")
