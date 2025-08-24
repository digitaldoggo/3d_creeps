extends Node

@export var mob_scene: PackedScene

var can_retry = false

func _ready() -> void:
	$UserInterface/GameOver.hide()
	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept") and can_retry:
		can_retry = false
		get_tree().reload_current_scene()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	

func _on_player_hit() -> void:
	game_over()
		
func game_over():
	$MobTimer.stop()
	$UserInterface/GameOver.show()
	$UserInterface/GameOver/Message.text = "Game Over"
	if $RespawnTimer.is_stopped():
		$RespawnTimer.start()

func _on_respawn_timer_timeout() -> void:
	$UserInterface/GameOver/Message.text = "Press Enter or Jump to Retry"
	can_retry = true
