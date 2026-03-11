extends CharacterBody2D

#signal caught_cat(cat_name)

@export var speed: float = 300.0
@export var player: Node2D
@export var cat_name: int
#making it a number
@onready var game_manager = get_parent().get_parent()

@export var panic_distance: float = 250.0 
@export var safe_distance: float = 600.0 

@export var hideouts_container: Node2D
@export var tunnels: Node2D
@onready var all_tunnels = $"../../Tunnels".get_children()
var random_number: int
# Referenzen
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_hiding = false
# Die states
enum State { IDLE, FLEEING, GOING_TO_HIDE, HIDDEN }
var current_state = State.IDLE

var can_use_tunnel = true



func _ready():
	if Global.cats_found_state.has(cat_name):
		if Global.cats_found_state[cat_name] == true:
			queue_free()
			return 
	set_cat_visuals()
	# Navigations Setup
	nav_agent.path_desired_distance = 20.0
	nav_agent.target_desired_distance = 20.0
	Global.Psps.connect(_on_player_ruft)
	
	random_number_generator()
	anim_sprite.play("idle")
	
	#if anim_sprite: anim_sprite.play("idle") #need to add idle

func _physics_process(_delta):
	player_is_sneaking()
	if !player: return
	

	var dist_to_player = global_position.distance_to(player.global_position)

	match current_state:
		State.IDLE:
			if dist_to_player < panic_distance:
				print("Panik")
				change_state(State.FLEEING)
				
		State.FLEEING:
			_flee_from_player()
			if dist_to_player > safe_distance:
				print("Safe")
				start_going_to_hide()
				
		State.GOING_TO_HIDE:
			if nav_agent.is_navigation_finished():
				enter_hidden_mode()
				is_hiding = true
			else:
				is_hiding = false
				# Falls der Spieler einholt
				if dist_to_player < panic_distance:
					print("got you")
					current_state = State.FLEEING
				else:
					_move_along_path()

		State.HIDDEN:
			if dist_to_player < panic_distance:
				print("Gefunden! Panik!")
				anim_sprite.visible = true
				change_state(State.FLEEING)
				
				#if anim_sprite: anim_sprite.play("run")



func _flee_from_player():
	var nearest_tunnel = get_nearest_tunnel()
	var dist_to_tunnel = INF
	var dist_to_player = global_position.distance_to(player.global_position)
	if nearest_tunnel:
		dist_to_tunnel = global_position.distance_to(nearest_tunnel.global_position)

	
	if dist_to_tunnel < 30.0:
		if can_use_tunnel:
			spawning_at_new_tunnel(nearest_tunnel)
			return

	elif dist_to_tunnel < 100 and can_use_tunnel and dist_to_player < 150:
		nav_agent.target_position = nearest_tunnel.global_position
		
		
	else:
		var dir_away = (global_position - player.global_position).normalized()
		var target = global_position + (dir_away * 500.0)
		nav_agent.target_position = target

	# Bewegung ausführe
	_move_along_path()

func start_going_to_hide():
	var spot = get_nearest_hideout()
	if spot:
		current_state = State.GOING_TO_HIDE
		nav_agent.target_position = spot.global_position
	else:
		# Falls keine Marker
		current_state = State.FLEEING

 

func get_nearest_hideout() -> Node2D:
	if not hideouts_container:
		return null
	var all_hideouts = hideouts_container.get_children()
	if not hideouts_container:
		print("Fehler: Node 'Hideouts_container' nicht gefunden")
		return null
	#setzte es unendlich und wenn dann geschaut wird ob es näher ist,
	#ist es beim ersten mal immer korrekt und geht dann von da aus alle anderen durch
	var nearest_node = null
	var shortest_distance = INF 
	
	for hideout in all_hideouts:
		# Distanz berechnen
		var distance = global_position.distance_to(hideout.global_position)
		
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_node = hideout
	return nearest_node
	
	

func _move_along_path():
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	

	
	if anim_sprite:
		
		if velocity.x < -0.1: 
			anim_sprite.flip_h = false 
			
		elif velocity.x > 0.1: 
			anim_sprite.flip_h = true 
			
	move_and_slide()

func enter_hidden_mode():
	change_state(State.HIDDEN)
	velocity = Vector2.ZERO
	if anim_sprite:
		#anim_sprite.play("idle")
		anim_sprite.visible = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("caught cat number: ", cat_name)
		
		Global.register_cat_found(cat_name)
		
		# Jetzt die Katze entfernen
		queue_free()

func _on_player_ruft():
	if is_hiding == true:
		print("Cat sound")
		$AudioStreamPlayer2D.play()
	else:
		pass

func player_is_sneaking():
	if Global.is_sneaking and is_hiding: 
		panic_distance = 5
		print("panic distnace:\n", panic_distance)
	else:
		panic_distance = 50

#func _on_cat_caught():
	#print()

func random_number_generator():
	random_number = randi_range(1, 17)
	
func change_state(new_state):
	# Wenn wir schon in dem Zustand sind, nichts tun
	if current_state == new_state:
		return
	
	var was_in_danger = (current_state == State.FLEEING or current_state == State.GOING_TO_HIDE)
	var is_now_in_danger = (new_state == State.FLEEING or new_state == State.GOING_TO_HIDE)
	
	
	if is_now_in_danger and not was_in_danger:
		game_manager.cat_started_fleeing()
	
	elif not is_now_in_danger and was_in_danger:
		game_manager.cat_stopped_fleeing()
	
	current_state = new_state

	if anim_sprite:
		match current_state:
			State.IDLE:
				anim_sprite.play("idle")
			
			State.FLEEING:
				anim_sprite.play("run")
			
			State.GOING_TO_HIDE:
				anim_sprite.play("run")
			
			State.HIDDEN:
				anim_sprite.visible = false
func set_cat_visuals():
	var skin_path = ""
	
	match cat_name:
		1: skin_path = "res://Animations/cat_1_skin.tres"
		2: skin_path = "res://Animations/cat_2.tres"
		3: skin_path = "res://Animations/cat_3.tres"
		4: skin_path = "res://Animations/cat_4.tres"
		5: skin_path = "res://Animations/cat_5.tres"
		_:
			print("Fehler: No skin defined for cat number ", cat_name)
			return

	
	if ResourceLoader.exists(skin_path):
		var frames = load(skin_path)
		if frames is SpriteFrames:
			anim_sprite.sprite_frames = frames
			anim_sprite.play("idle")
			print("Skin geladen für Katze ", cat_name)
		else:
			printerr("Fehler: Datei ist kein SpriteFrames-Typ!")
			
	else:
		printerr("Kritisch: Resource nicht gefunden: ", skin_path)

func get_nearest_tunnel() -> Node2D:
	
	if not tunnels:
		return null
		

	var nearest_tunnel = null
	var shortest_distance = INF 
	
	for tunnel in all_tunnels:
		# Distanz berechnen
		var distance = global_position.distance_to(tunnel.global_position)
		
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_tunnel = tunnel
	return nearest_tunnel
	
func spawning_at_new_tunnel(entered_tunnel):
	#scheint zu funktionieren
	
	var possible_targets = all_tunnels.duplicate()
	can_use_tunnel = false
	
	possible_targets.erase(entered_tunnel)#löschen damit nicht am selben marker spawnt

	#check
	if possible_targets.size() > 0:
		var target_tunnel = possible_targets.pick_random()
		# Teleportieren
		global_position = target_tunnel.global_position
		await get_tree().create_timer(10).timeout
		can_use_tunnel = true
		print("Teleportiert" , target_tunnel)
		return
	else:
		print("Keine anderen Tunnel gefunden!")
	
	
