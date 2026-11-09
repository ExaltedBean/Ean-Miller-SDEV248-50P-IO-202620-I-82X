extends CharacterBody2D

const SPEED = 100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = -1

@onready var sprite = $AnimatedSprite2D

func _ready():

	sprite.play("walk")

	sprite.visible = false

	set_physics_process(false)


func _on_visible_on_screen_notifier_2d_screen_entered():

	sprite.visible = true

	set_physics_process(true)


func _on_visible_on_screen_notifier_2d_screen_exited():

	sprite.visible = false

	set_physics_process(false)


func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = direction * SPEED

	move_and_slide()

	if is_on_wall():
		direction *= -1

	sprite.flip_h = direction > 0
