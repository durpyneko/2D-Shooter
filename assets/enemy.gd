extends CharacterBody2D

class_name Enemy

@onready var _animated_sprite = $AnimatedSprite2D
@export var damage: float = 30.0
var health: float = 100.0
var speed: float = 200.0
var target: Player

func _physics_process(delta: float) -> void:
	if target == null: target = get_tree().get_nodes_in_group("Player")[0] # Array
	if target != null:
		velocity = position.direction_to(target.position) * speed
		_animated_sprite.play()
		look_at(target.global_position)
		move_and_slide()
	if is_instance_valid($ProgressBar):
		if health > 50:
			$ProgressBar.modulate = Color(0, 1, 0) # green
		elif health >= 30:
			$ProgressBar.modulate = Color(1, 1, 0) # oragnge??
		else:
			$ProgressBar.modulate = Color(1, 0, 0) # red

func _on_CollisionShape2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		# Inflict damage to the player
		body.take_damage(damage)

func apply_damage(damage: float) -> void:
	health = clamp(health - damage, 0.0, 100.0)
	if is_instance_valid($ProgressBar):
		$ProgressBar.value = health
	# print("Health:", health)
	if health == 0.0:
		GameManager.handle_enemy_death()
		queue_free()
