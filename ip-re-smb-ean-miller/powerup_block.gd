extends StaticBody2D

enum RewardType {
	DNA,
	MINOR,
	MAJOR
}

@export var reward_type = RewardType.DNA

const DNA_PICKUP = preload("res://dna_pickup.tscn")
const MINOR_POWERUP = preload("res://minor_powerup.tscn")
const MAJOR_POWERUP = preload("res://major_powerup.tscn")

var used = false

func _ready():
	$AnimatedSprite2D.play("unused")

func activate():

	if used:
		return

	used = true

	print("Block Activated")

	$AnimatedSprite2D.play("used")

	var reward

	match reward_type:

		RewardType.DNA:
			reward = DNA_PICKUP.instantiate()

		RewardType.MINOR:

			if GameManager.form == GameManager.Forms.SOOT:
				reward = MINOR_POWERUP.instantiate()
			elif GameManager.form == GameManager.Forms.PARTIAL:
				reward = MAJOR_POWERUP.instantiate()
			else:
				reward = DNA_PICKUP.instantiate()

		RewardType.MAJOR:

			if GameManager.form == GameManager.Forms.SOOT:
				reward = MINOR_POWERUP.instantiate()
			elif GameManager.form == GameManager.Forms.PARTIAL:
				reward = MAJOR_POWERUP.instantiate()
			else:
				reward = DNA_PICKUP.instantiate()

	if reward:
		get_parent().add_child(reward)
		reward.global_position = global_position + Vector2(0, -64)
