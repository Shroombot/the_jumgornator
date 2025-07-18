extends CanvasLayer
@export var switch = false

func _ready() -> void:
	get_tree().paused = false
	#print(load(get_tree().current_scene.scene_file_path))
	$ColorRect/AnimationPlayer.play("in")

func _process(delta: float) -> void:
	if Everywhere.show_letter:
		$letter_stuff/title.text = Everywhere.letter_contents[0]
		$letter_stuff/contents.text = Everywhere.letter_contents[1]
		var tween = create_tween()
		tween.tween_property($letter_stuff,"modulate:a",1,0.1)
		$letter_stuff/close.visible = true
	else:
		var tween = create_tween()
		tween.tween_property($letter_stuff,"modulate:a",0,0.1)
		$letter_stuff/close.visible = false
	if Input.is_action_just_pressed("reload"):
		Everywhere.scene = get_tree().current_scene.scene_file_path
		Everywhere.switch_scene = true
	if Input.is_action_just_pressed("menu"):
		if get_tree().paused:
			get_tree().paused = false
			var tween = create_tween().set_parallel()
			$pause.visible = true
			tween.tween_property($VBoxContainer,"modulate:a",0,0.2)
			tween.tween_property($pause_menu,"modulate:a",0,0.2)
			await get_tree().create_timer(0.3).timeout
			$VBoxContainer.visible = false
		else:
			$pause_menu/pause.pitch_scale = randf_range(0.95,1.05)
			$pause_menu/pause.play()
			var tween = create_tween().set_parallel()
			$pause.visible = false
			$VBoxContainer.visible = true
			tween.tween_property($VBoxContainer,"modulate:a",1,0.2)
			tween.tween_property($pause_menu,"modulate:a",1,0.2)
			await get_tree().create_timer(0.3).timeout
			get_tree().paused = true
	if switch:
		switch = false
		
		#print(Everywhere.scene)
		get_tree().change_scene_to_file(Everywhere.scene)
		Everywhere.scene = ""
	if Everywhere.switch_scene:
		$ColorRect/AnimationPlayer.play("out")
		Everywhere.switch_scene = false
	if not Everywhere.unlock_text.is_empty():
		var tween = create_tween()
		tween.tween_property($RichTextLabel,"modulate:a",1,0.2)
		if Everywhere.unlock_text[1] == "none":
			$RichTextLabel.text = "Consumed [wave amp=10.0 freq=5]" + Everywhere.unlock_text[0] + "[/wave]."
		else:
			$RichTextLabel.text = "Consumed [wave amp=10.0 freq=5]" + Everywhere.unlock_text[0] + "[/wave]. Activate by pressing [shake rate=15.0 level=2]" + Everywhere.unlock_text[1] + "[/shake]."
		Everywhere.unlock_text.clear()
		await get_tree().create_timer(2).timeout
		var tweens = create_tween()
		tweens.tween_property($RichTextLabel,"modulate:a",0,0.2)

func _on_pause_pressed() -> void:
	$pause_menu/pause.pitch_scale = randf_range(0.95,1.05)
	$pause_menu/pause.play()
	var tween = create_tween().set_parallel()
	$pause.visible = false
	$VBoxContainer.visible = true
	tween.tween_property($VBoxContainer,"modulate:a",1,0.2)
	tween.tween_property($pause_menu,"modulate:a",1,0.2)
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = true
	

func _on_continue_pressed() -> void:
	$pause_menu/click.pitch_scale = randf_range(0.95,1.05)
	$pause_menu/click.play()
	get_tree().paused = false
	var tween = create_tween().set_parallel()
	$pause.visible = true
	tween.tween_property($VBoxContainer,"modulate:a",0,0.2)
	tween.tween_property($pause_menu,"modulate:a",0,0.2)
	await get_tree().create_timer(0.3).timeout
	$VBoxContainer.visible = false
	

func _on_reset_level_pressed() -> void:
	$pause_menu/click.pitch_scale = randf_range(0.95,1.05)
	$pause_menu/click.play()
	get_tree().paused = false
	Everywhere.scene = get_tree().current_scene.scene_file_path
	Everywhere.switch_scene = true

func _on_skip_pressed() -> void:
	$pause_menu/click.pitch_scale = randf_range(0.95,1.05)
	$pause_menu/click.play()
	get_tree().paused = false
	Everywhere.change_level(Everywhere.level + 1)

func _on_close_pressed() -> void:
	Everywhere.show_letter = false
