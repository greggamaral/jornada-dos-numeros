extends Sprite2D

@onready var scene_transition_anim = $"../SceneTransitionAnimation/AnimationPlayer"

var colors: Array[Color] = []
var current_voice_index: int = 0
var voices = DisplayServer.tts_get_voices_for_language("pt_BR")
var can_interact: bool = false

func _ready():
	DisplayServer.tts_stop()
	scene_transition_anim.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	$"../SelectionExplanation".play()
	await get_tree().create_timer(6).timeout
	$"../ConfirmationExplanation".play()
	await get_tree().create_timer(4).timeout
	for _i in len(voices):
		colors.append(Color(randf(), randf(), randf()))
	update_color()
	$AnimatedSprite2D.play("default")
	can_interact = true

func _process(delta):
	if can_interact:
		if Input.is_action_just_pressed("ui_right"):
			current_voice_index = (current_voice_index + 1) % voices.size()
			update_color()
		elif Input.is_action_just_pressed("ui_left"):
			current_voice_index = (current_voice_index - 1) % voices.size()
			update_color()
		elif Input.is_action_just_pressed("ui_accept"):
			select_voice()

func update_color():
	DisplayServer.tts_stop()
	$AnimatedSprite2D.modulate = colors[current_voice_index]
	var voice_id = voices[current_voice_index]
	DisplayServer.tts_speak("Olá! O que você acha dessa voz?", voice_id, AudioController.volume, 1.0, 1.0)

func select_voice():
	DisplayServer.tts_stop()
	Global.selected_voice_id = current_voice_index
	can_interact = false
	DisplayServer.tts_speak("Você me escolheu! Vamos juntos nessa aventura!", voices[current_voice_index], AudioController.volume, 1.0, 1.0)
	await get_tree().create_timer(3).timeout
	$"../Label".text = ""
	scene_transition_anim.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/level_selection/level_selection.tscn")
