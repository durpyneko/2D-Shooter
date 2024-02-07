extends CharacterBody2D

class_name Player

var health: float = 100.0
@export var damage: float = 30.0
@export var speed = 600
@export var bullet_speed = 900
@export var shoot_timer := 0.0
@export var shoot_interval := 0.2
@export var projectile = preload("res://scenes/bullet.tscn")
@onready var hud_scene: PackedScene = load("res://scenes/hud.tscn")
@onready var spawn_point: Marker2D = $Marker2D

@onready var game_manager = get_node("/root/GameManager")
var health_bar: ProgressBar
var shoot_sound: AudioStreamPlayer

func _ready():
	health_bar = game_manager.hud_instance.get_node("HealthBar")
	if health_bar:
		health_bar.value = health
	else:
		print("Error: HealthBar not found.")
	
	shoot_sound = $AudioStreamPlayer
	pass
	
func _physics_process(delta) -> void:
	health = clamp(health, 0.0, 100.0)
	health_bar.value = health
	get_input()
	move_and_slide()
	update_hud()
	look_at(get_global_mouse_position())
	
	if is_instance_valid(health_bar):
		if health > 50:
			health_bar.modulate = Color(0, 1, 0) # green
		elif health >= 30:
			health_bar.modulate = Color(1, 1, 0) # oragnge??
		else:
			health_bar.modulate = Color(1, 0, 0) # red
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
		shoot_timer = 0.0

	if Input.is_action_pressed("shoot"):
		shoot_timer += delta
		if shoot_timer >= shoot_interval:
			shoot()
			shoot_timer = 0.0

func get_input() -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

func take_damage(damage: float) -> void:
	print("DAMAGE PLAYER")
	health = clamp(health - damage, 0.0, 100.0)

func shoot() -> void:
	var bullet: Projectile = projectile.instantiate()
	bullet.spawned_from = self
	owner.add_child(bullet)
	shoot_sound.play()
	bullet.transform = spawn_point.global_transform

func update_hud() -> void:
	pass
