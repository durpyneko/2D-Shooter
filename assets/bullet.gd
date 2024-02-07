extends Area2D

class_name Projectile

@export var speed: float = 750.0
@export var damage: float = 30.0
@export var time_to_live: float = 0.8
@export var spawned_from: Node

func _ready() -> void:
	body_entered.connect(on_body_entered)
	handle_time_to_live()
	
func handle_time_to_live() -> void:
	var ttl_timer: Timer = Timer.new()
	add_child(ttl_timer)
	ttl_timer.wait_time = time_to_live
	ttl_timer.one_shot = true
	ttl_timer.timeout.connect(func(): queue_free())
	ttl_timer.start()

func _physics_process(delta):
	position += transform.x * speed * delta

func on_body_entered(body: Node2D) -> void:
	if body is Player: return
	if body is Enemy:
		var enemy: Enemy = body as Enemy
		enemy.apply_damage(damage)
	queue_free()
