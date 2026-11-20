extends Node2D

@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("idle")

func _input(event):
	if event.is_action_pressed("ui_left"):
		anim_player.play("idle")

	if event.is_action_pressed("ui_right"):
		anim_player.play("walk")
