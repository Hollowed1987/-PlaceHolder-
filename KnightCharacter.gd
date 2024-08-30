extends CharacterBody2D
@export var speed = 500.0
@export var gravity = 900
@export var jumpForce = 650
@export var health = 100
var isJumping = false
var isAttacking = false 

signal take_damage(damage)

func _ready():
	$KnightCharacterSprite.animation_finished.connect(_on_animation_finished)
	connect("take_damage", Callable(self, "_on_take_damage"))

func _on_take_damage(damage):
	print("Damage taken:", damage)
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()
	
func _physics_process(delta):
	print(health)
	var direction = Input.get_axis("KnightLeft", 'KnightRight')
	
	if direction:
		velocity.x = direction * speed
		if is_on_floor() and not isAttacking:
			$KnightCharacterSprite.play("Run")
	else:
		velocity.x = 0 
		if is_on_floor() and not isAttacking:
			$KnightCharacterSprite.play("Idle")
	
	if direction == 1:
		$KnightCharacterSprite.flip_h = false
	elif direction == -1:
		$KnightCharacterSprite.flip_h = true
	
	if Input.is_action_just_pressed('KnightUp') and is_on_floor() and not isAttacking:
		velocity.y = -jumpForce
		isJumping = true
		$KnightCharacterSprite.play("Jump")
	
	if Input.is_action_pressed('KnightDown'):
		position.y += 1
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:  # If moving downwards
			if $KnightCharacterSprite.animation != "Fall" and not isAttacking:
				$KnightCharacterSprite.play("Fall")
		else:  # If moving upwards or at the peak of the jump
			if $KnightCharacterSprite.animation != "Jump":
				$KnightCharacterSprite.play("Jump")
	else:
		isJumping = false
	
	move_and_slide()
	
	# Call the attack function if the attack input action is pressed
	if Input.is_action_just_pressed("KnightAttack") and is_on_floor() and not isAttacking:
		isAttacking = true
		$KnightCharacterSprite.play("attack1")

func _on_animation_finished():
	if $KnightCharacterSprite.animation == "attack1":
		isAttacking = false


func _on_death_box_collision_area_entered(area):
	if area.is_in_group("deathBox"):
		position.x = 908
		position.y = -390


func _on_attack_animation_1_body_entered(body):
	pass # Replace with function body.
