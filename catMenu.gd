extends CharacterBody2D

@export var footprint_scene: PackedScene
@export var speed: float = 100
@export var step_distance: float = 30.0
@export var step_width: float = 5.0
@export var name_of: int = 1 #1 = jeremiah
var direction: Vector2
var screen_size: Vector2
var timer: int = 0

var distance_traveled: float = 0.0
var is_left_foot: bool = true 


	
 
   

func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	#muss es hier wieder unischtbar machen
	if has_node("Sprite2D"):
		$Sprite2D.visible = false 
		

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	 
	
	#schaut in Laufrichtung
	if velocity.length() > 0:
		look_at(global_position + velocity)
	
	move_and_slide()
	
	if global_position.x <= 0 or global_position.x >= screen_size.x:
		direction.x = -direction.x
		global_position.x = clamp(global_position.x, 1, screen_size.x - 1)
		
	if global_position.y <= 0 or global_position.y >= screen_size.y:
		direction.y = -direction.y
		global_position.y = clamp(global_position.y, 1, screen_size.y - 1)

	
	distance_traveled += velocity.length() * delta
	
	if distance_traveled >= step_distance:
		spawn_footprint()
		distance_traveled = 0.0 # Reset 
	
	check_avoidance()
	
func spawn_footprint() -> void:
	if !footprint_scene:
		return
	var footprint = footprint_scene.instantiate()
	
	var offset = Vector2.ZERO
	
	if is_left_foot:
		offset = -transform.y * step_width
	else:
		offset = transform.y * step_width
	
	# Toggle für nächstes Mal
	is_left_foot = !is_left_foot
	
	footprint.global_position = global_position + offset
	footprint.rotation = rotation # Rotation des Spielers übernehmen
	footprint.z_index = -1    # Auf den Boden malen
	footprint.setup_sprite(name_of)
	get_tree().current_scene.add_child(footprint)


func check_avoidance():
	var areas = $Detector.get_overlapping_areas()
	
	for area in areas:
		if area.is_in_group("Forbidden"):
			
			# Berechnung des Fluchtwegs
			var flee_vector = global_position - area.global_position
			
			if flee_vector.length() < 0.1:
				flee_vector = Vector2(1, 0) 
			
			direction = flee_vector.normalized()
			#print("flee")
			return


func _on_timer_cat_1_timeout():
	timer+= 1
	if timer > 1:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	else:
		direction = Vector2(1,-1)


func _on_timer_cat_2_timeout():
	timer += 1
	if timer > 1:
		var nr = int(randf_range(0,3))
		if nr < 2:
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		else:
			direction = Vector2(0,0)
	else:
		direction = Vector2(1,0)

func _on_timer_cat_3_timeout():
	timer += 1
	if timer > 1:
		var nr = int(randf_range(0,6))
		if nr < 5:
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		else:
			direction = Vector2(0,0)
	else:
		direction = Vector2(0,1)

func _on_timer_cat_4_timeout():
	timer += 1
	if timer > 1:
		var nr = int(randf_range(0,5))
		if nr < 3:
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		else:
			direction = Vector2(0,0)
	else:
		direction = Vector2(0,-1)

func _on_timer_cat_5_timeout():
	timer+= 1
	if timer > 1:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	else:
		direction = Vector2(-1,1)
