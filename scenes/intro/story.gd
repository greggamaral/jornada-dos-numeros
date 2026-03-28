extends Node2D

@onready var scene_transition_anim = $"SceneTransitionAnimation/AnimationPlayer"

func _ready():
	scene_transition_anim.play("fade_out")
	await get_tree().create_timer(0.5).timeout

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/intro/voice_selection.tscn")
	else:
		$AnimationPlayer.play("1")
		await get_tree().create_timer(95).timeout
		scene_transition_anim.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/intro/voice_selection.tscn")
