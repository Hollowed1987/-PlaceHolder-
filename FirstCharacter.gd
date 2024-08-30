extends CharacterBody2D
@export var speed = 620.0
@export var gravity = 900
@export var jumpForce = 650
@export var health = 100
var isJumping = false
var isAttacking = false 

signal take_damage(damage)


func _ready():
	$MonkCharacterSprite.animation_finished.connect(_on_animation_finished)
	connect("take_damage", Callable(self, "_on_take_damage"))

func _on_take_damage(damage):
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", 'ui_right')
	
	if direction:
		velocity.x = direction * speed
		if is_on_floor() and not isAttacking:
			$MonkCharacterSprite.play("Run")
	else:
		velocity.x = 0 
		if is_on_floor() and not isAttacking:
			$MonkCharacterSprite.play("Idle")
	
	if direction == 1:
		$MonkCharacterSprite.flip_h = false
	elif direction == -1:
		$MonkCharacterSprite.flip_h = true
	
	if Input.is_action_just_pressed('ui_up') and is_on_floor() and not isAttacking:
		velocity.y = -jumpForce
		isJumping = true
		$MonkCharacterSprite.play("Jump")
		
	if Input.is_action_pressed('ui_down'):
		position.y += 1
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:  # If moving downwards
			if $MonkCharacterSprite.animation != "Fall" and not isAttacking:
				$MonkCharacterSprite.play("Fall")
		else:  # If moving upwards or at the peak of the jump
			if $MonkCharacterSprite.animation != "Jump":
				$MonkCharacterSprite.play("Jump")
	else:
		isJumping = false
	
	move_and_slide()
	
	# Call the attack function if the attack input action is pressed
	if Input.is_action_just_pressed("MonkAttack") and is_on_floor() and not isAttacking:
		isAttacking = true
		$MonkCharacterSprite.play("attack1")
		$MonkCharacterSprite/attackAnimation1/CollisionPolygon2D.disabled = false
	if isAttacking == false:
		$MonkCharacterSprite/attackAnimation1/CollisionPolygon2D.disabled = true
	
func _on_animation_finished():
	if $MonkCharacterSprite.animation == "attack1":
		isAttacking = false


func _on_area_2d_area_entered(area):
	if area.is_in_group("deathBox"):
		position.x -= 700
		#position.x = 908
		#position.y = -390


func _on_attack_animation_1_body_entered(body):
	pass # Replace with function body.
