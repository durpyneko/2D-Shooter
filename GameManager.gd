extends Node

@onready var enemy_scene: PackedScene = load("res://enemy.tscn")
@onready var hud_scene: PackedScene = load("res://hud.tscn")
@onready var pause_menu_scene: PackedScene = load("res://pause_menu.tscn")

var wave: int = 1
var enemies_remaining: int = 2
var spawn_count: int = 0
var spawn_points: Array[Node] = []
var level: Node2D
var background = ColorRect
var spawn_timer: Timer
var time_between_spawns: float = 1.0
var hud_instance: Node
var is_paused: bool = false
var pause_menu_instance: CanvasLayer

func _ready() -> void:
	level = get_tree().get_first_node_in_group("Level")
	spawn_points = get_tree().get_nodes_in_group("Spawn")
	hud_instance = hud_scene.instantiate()
	add_child(hud_instance)
	update_hud()
	pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
	pause_menu_instance.visible = false
	initialize_spawn_timer()
	handle_next_wave()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(true)

func initialize_spawn_timer() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = time_between_spawns
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(spawn_enemy)

func handle_next_wave() -> void:
	print("Wave: ", wave)
	print("Enemies: ", enemies_remaining)
	if wave % 5 == 0:
		time_between_spawns -= 0.1
	print("Time between spawns: ", str(time_between_spawns, "s"))
	spawn_timer.wait_time = max(0.1,  time_between_spawns)
	spawn_count = 0
	spawn_timer.start()
	update_hud()

func spawn_enemy() -> void:
	var random_spawn: Node = \
		spawn_points[randi_range(0, spawn_points.size() - 1)]
	var inst = enemy_scene.instantiate()
	level.add_child(inst)
	inst.global_position = random_spawn.global_position
	spawn_count += 1
	if spawn_count == wave * 2:
		spawn_timer.stop()

func handle_enemy_death() -> void:
	enemies_remaining -= 1
	update_hud()
	if enemies_remaining == 0:
		wave += 1
		enemies_remaining = wave * 2
		handle_next_wave()

func update_hud() -> void:
	var wave_label_hud = hud_instance.get_node("WaveLabel")
	var enemies_remaining_hud = hud_instance.get_node("EnemiesRemaining")
	var TimeBetweenSpawns = hud_instance.get_node("TimeBetweenSpawns")
	wave_label_hud.text = "Wave: " + str(wave)
	enemies_remaining_hud.text = "Enemies: " + str(enemies_remaining)
	TimeBetweenSpawns.text = "TBS: " + str(time_between_spawns) + "s"
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	if is_paused:
		# Pause the game
		get_tree().paused = true
		pause_menu_instance.visible = true  # show the pause menu
	else:
		# Unpause the game
		get_tree().paused = false
		pause_menu_instance.visible = false  # hide the pause menu


