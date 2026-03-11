extends CharacterBody2D

signal interact
signal health
"""
-Schauen das es auch heilitems gibt
-kamera später anpassen
"""


const pause_menu: PackedScene = preload("res://scenes/pausescreen.tscn")


var Character_stats = {"health_cap": 100, "health": 100, "aura_cap": 45, "aura": 45}
var max_health = Character_stats["health_cap"]
var current_health = Global.player_current_health


const WALK_SPEED = 70
const SNEAK_SPEED = 30
const DASH_SPEED = 150 

var speed: int = WALK_SPEED
var direction: Vector2 = Vector2.ZERO
var last_direction = Vector2.DOWN


var cooldown_over: bool = true
var idle_timer = 0.0


var footstep_sound_sets = { "outside": [], "running": [], "feld": [] }#akutalisieren wenn neuer bereich
var footstep_counters = { "outside": 0, "running": 0, "feld": 0 }#akutalisieren wenn neuer bereich


enum STATE {WALKING, RUNNING, IDLE, SNEAKING, TALKING}
var current_state = STATE.IDLE

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)
	$Label.visible = false

	
	# Sounds laden
	footstep_sound_sets["outside"].append(preload("res://assets/Audio/sfx/footsteps/Footsteps_Walk_Grass_Mono_01.wav"))
	footstep_sound_sets["outside"].append(preload("res://assets/Audio/sfx/footsteps/Footsteps_Walk_Grass_Mono_02.wav"))
	footstep_sound_sets["running"].append(preload("res://assets/Audio/sfx/footsteps/Footsteps_Grass_Run_01.wav"))
	footstep_sound_sets["running"].append(preload("res://assets/Audio/sfx/footsteps/Footsteps_Grass_Run_02.wav"))
	footstep_sound_sets["feld"].append(preload("res://assets/Audio/sfx/footsteps/Footsteps_Wood_Walk_01.wav"))
	footstep_sound_sets["feld"].append(preload("res://assets/Audio/sfx/footsteps/Footsteps_Wood_Walk_02.wav"))
#hier neue hinzufügen


func _physics_process(_delta: float) -> void:
	
	match current_state:
		STATE.IDLE:
			idle_logic()
		STATE.WALKING:
			#print("walking")
			walking_logic()
		STATE.RUNNING:
			running_logic() 
		STATE.SNEAKING:
			sneaking_logic()
		STATE.TALKING:
			#print("Talking")
			talking()
		
	if current_state != STATE.TALKING:
		getting_tip()
		interaction()
	getting_last_position()
	spawn_pause_menu()
	move_and_slide()

func change_state(new_state):
	if current_state == new_state and new_state != STATE.RUNNING:
		return
		
	current_state = new_state
	
	match current_state:
		STATE.IDLE:
			speed = 0
			$AnimatedSprite2D.stop()
			
		STATE.WALKING:
			speed = WALK_SPEED
			
			
		STATE.SNEAKING:
			speed = SNEAK_SPEED
			Global.is_sneaking = true
			$AudioStreamPlayer2D.volume_db = -10
			
		STATE.RUNNING: # DASH STARTEN
			if Global.number_of_cups > 0:
				Global.number_of_cups -= 1
				speed = DASH_SPEED
				Global.place = "running"
				$DashTimer.start() # Startet den Timer für die Dash-Dauer
			else:
				change_state(STATE.WALKING)

func idle_logic():
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		if Input.is_action_pressed("hide"):
			change_state(STATE.SNEAKING)
		else:
			change_state(STATE.WALKING)
	
	#dash nicht aus stand möglich
	#if Input.is_action_just_pressed("dash"):
		#change_state(STATE.RUNNING)

func walking_logic():
	handle_movement() 
	
	# wenn stehen
	if velocity.length() == 0:
		change_state(STATE.IDLE)
	
	# Wenn dashen
	if Input.is_action_just_pressed("dash"):
		change_state(STATE.RUNNING)
		
	# Wenn schleichen
	if Input.is_action_pressed("hide"):
		change_state(STATE.SNEAKING)

func running_logic():
	
	handle_movement()
	if velocity == Vector2.ZERO:
		change_state(STATE.WALKING)
	#DashTimer änder state


func sneaking_logic():
	handle_movement()
	
	if Input.is_action_just_released("hide"):
		Global.is_sneaking = false
		$AudioStreamPlayer2D.volume_db = 0
		change_state(STATE.WALKING)
		#theortisch wenn idle im sneaken
	#if velocity.length() == 0:
		#
		#pass

func handle_movement():
	if Global.current_level_node.name == "DialogScene":
		velocity = Vector2.ZERO
		return


	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

	if velocity.length() > 0:
		idle_timer = 0.0
		last_direction = direction.normalized()
		play_walking_animation()
		footstep_sound()
	else:
		$AnimatedSprite2D.stop()

func _on_dash_timer_timeout() -> void:
	change_state(STATE.WALKING)

func play_walking_animation():
	if current_state == STATE.RUNNING:
		# $AnimatedSprite2D.animation = 'running' 
		$AnimatedSprite2D.animation = 'walking' 
	else:
		$AnimatedSprite2D.animation = 'walking'
	
	if direction.x != 0:
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		$AnimatedSprite2D.flip_h = false
	
	$AnimatedSprite2D.play()

func footstep_sound():
	var current_place = Global.place
	if not footstep_sound_sets.has(current_place): return
	
	var sounds_to_play = footstep_sound_sets[current_place]
	if sounds_to_play.is_empty(): return
	
	var current_index = footstep_counters[current_place]
	
	if not $AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.stream = sounds_to_play[current_index]
		$AudioStreamPlayer2D.play()
		footstep_counters[current_place] = (current_index + 1) % sounds_to_play.size()

func interaction():
	if Input.is_action_just_pressed("talk"):
		interact.emit()

func getting_tip():
	if Input.is_action_just_pressed("hint") and cooldown_over:
		$Cooldown.start()
		$Label.visible = true
		$AnimationPlayer.play("Pspsps")
		$PspsTimer.start()
		Global.Psps.emit()
		cooldown_over = false

func _on_cooldown_timeout() -> void:
	cooldown_over = true

func _on_psps_timer_timeout():
	$Label.visible = false

func getting_last_position():
	Global.player_current_position = global_position

func _on_dialogue_finished(_resource: Resource):
	print("dialogue finished")
	change_state(STATE.WALKING)
	
func talking():
	#playing idle
	pass

func spawn_pause_menu() -> void:
	if Input.is_action_just_pressed("pause") and Global.pause_menu == false:
		var menu_instance = pause_menu.instantiate()
		add_child(menu_instance)
		Global.pause_menu = true
		#get_tree().paused = true # falls ich spiel pausieren möchte -> muss angepasst werden
		
