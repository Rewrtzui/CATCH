extends CanvasLayer




@export var bilder_pfade: Array[Texture2D] = []
var aktueller_index: int = 0
var end: bool = false
@onready var display_rect = $TextureRect
@onready var anim_player = $AnimationPlayer
#@onready var timer = $STimer

func _ready():
	$Label.visible = false
	if bilder_pfade.size() > 0:
		aktualisiere_anzeige()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			naechstes_bild()


func naechstes_bild():
	if bilder_pfade.size() == 0: return
	
	aktueller_index = (aktueller_index + 1) % bilder_pfade.size()
	aktualisiere_anzeige()
	
	#if timer:
		#timer.start() 

func aktualisiere_anzeige():
	display_rect.texture = bilder_pfade[aktueller_index]
	if anim_player.has_animation("fade_in"):
		anim_player.play("fade_in")


func _process(_delta):
	if aktueller_index == 17:
		$Label.visible = true
