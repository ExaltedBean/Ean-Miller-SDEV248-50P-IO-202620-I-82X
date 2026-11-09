extends CharacterBody2D

var hud = null
var lives_label = null
var pickup_label = null

@onready var anim = $AnimatedSprite2D

const SPEED = 400.0
const JUMP_VELOCITY = -900.0

const BASE_SCALE = Vector2(2, 2)
const POWERED_SCALE = Vector2(2.5, 2.5)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5

var invincible = false


func _ready():

	if get_tree().current_scene.has_node("HUD"):

		hud = get_tree().current_scene.get_node("HUD")

		lives_label = hud.get_node("Lives")
		pickup_label = hud.get_node("PickupCount")

	refresh_form()
	update_hud()


func _physics_process(delta):

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal Movement
	var direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	update_animation(direction)

	var previous_y_velocity = velocity.y

	move_and_slide()

	for i in range(get_slide_collision_count()):

		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		# Enemy Collision
		if collider.is_in_group("enemy"):

			# Stomp enemy
			if previous_y_velocity > 100 and global_position.y < collider.global_position.y:

				collider.queue_free()
				velocity.y = -500
				break

			# Take damage
			else:

				take_damage()
				break

		# Powerup Block Collision
		if previous_y_velocity < -100:

			if collider.has_method("activate"):
				collider.activate()


func update_animation(direction):

	# SOOT
	if GameManager.form == GameManager.Forms.SOOT:

		if not is_on_floor():

			if velocity.y < 0:
				anim.play("jump")
			else:
				anim.play("fall")

		elif direction > 0:
			anim.play("run_right")

		elif direction < 0:
			anim.play("run_left")

		else:
			anim.play("idle")

	# PARTIAL
	elif GameManager.form == GameManager.Forms.PARTIAL:

		if not is_on_floor():

			if velocity.y < 0:
				anim.play("jump")
			else:
				anim.play("fall")

		elif direction > 0:
			anim.play("run_right")

		elif direction < 0:
			anim.play("run_left")

		else:
			anim.play("idle2")

	# STABLE
	elif GameManager.form == GameManager.Forms.STABLE:

		if not is_on_floor():

			if velocity.y < 0:
				anim.play("jump2")
			else:
				anim.play("fall2")

		elif direction > 0:
			anim.play("run_right2")

		elif direction < 0:
			anim.play("run_left2")

		else:
			anim.play("idle3")


func refresh_form():

	match GameManager.form:

		GameManager.Forms.SOOT:
			anim.scale = BASE_SCALE

		GameManager.Forms.PARTIAL:
			anim.scale = POWERED_SCALE

		GameManager.Forms.STABLE:
			anim.scale = POWERED_SCALE


func gain_minor_powerup():

	if GameManager.form == GameManager.Forms.SOOT:

		GameManager.form = GameManager.Forms.PARTIAL

		refresh_form()

		print("Partial Mimic Form")

	elif GameManager.form == GameManager.Forms.PARTIAL:

		add_dna()

	elif GameManager.form == GameManager.Forms.STABLE:

		add_dna()


func gain_major_powerup():

	if GameManager.form != GameManager.Forms.STABLE:

		GameManager.form = GameManager.Forms.STABLE

		refresh_form()

		print("Stable Mimic Form")

	else:

		add_dna()


func add_dna(amount = 1):

	GameManager.dna_collected += amount

	update_hud()


func take_damage():

	if invincible:
		return

	invincible = true

	# Knockback
	velocity.y = -400

	if velocity.x >= 0:
		velocity.x = -300
	else:
		velocity.x = 300

	# STABLE -> PARTIAL
	if GameManager.form == GameManager.Forms.STABLE:

		GameManager.form = GameManager.Forms.PARTIAL

		refresh_form()

		await get_tree().create_timer(1.0).timeout

		invincible = false
		return

	# PARTIAL -> SOOT
	if GameManager.form == GameManager.Forms.PARTIAL:

		GameManager.form = GameManager.Forms.SOOT

		refresh_form()

		await get_tree().create_timer(1.0).timeout

		invincible = false
		return

	# SOOT -> Lose Life
	# SOOT -> Lose Life
	GameManager.lives -= 1

	GameManager.dna_collected = floor(GameManager.dna_collected / 2.0)

	update_hud()

	print("Lives:", GameManager.lives)

	if GameManager.lives <= 0:

		GameManager.lives = 3
		GameManager.dna_collected = 0
		GameManager.form = GameManager.Forms.SOOT

		get_tree().change_scene_to_file("res://game_over.tscn")
		return

	await get_tree().create_timer(1.0).timeout

	get_tree().reload_current_scene()


func update_hud():

	if lives_label:
		lives_label.text = "Lives remaining: " + str(GameManager.lives)

	if pickup_label:
		pickup_label.text = "DNA collected: " + str(GameManager.dna_collected)
