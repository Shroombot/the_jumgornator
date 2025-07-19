extends Area2D
@export var symbol_name = "jump"
@export var cancel_velocity = false
@export var amount = 0
var info = ["res://assets/symbols/jump.png","none","res://sounds/collect.mp3"]

func _ready() -> void:
	for i in Everywhere.symbols:
		#print(i)
		if i == symbol_name:
			info = Everywhere.symbols[i]
	if info[2] != "none":
		$collect.stream = load(info[2])
	$Sprite2D.texture = load(info[0])
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D,"scale",Vector2(1.1,1.1),0.75)
	tween.tween_property($Sprite2D,"scale",Vector2(1,1),0.75)

func _on_timer_timeout() -> void:
	monitoring = true
	$Sprite2D.visible = true


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$collect.pitch_scale = randf_range(0.95,1.05)
		$collect.play()
		if cancel_velocity:
			body.velocity = Vector2.ZERO
		body.eating = true
		#var tween = create_tween()
		#tween.tween_property(self,"global_position",body.global_position,0.2)
		await get_tree().create_timer(0.1).timeout
		if amount != 0:
			Everywhere.add_symbol(symbol_name, info[1], amount)
		else:
			if symbol_name == "draft":
				Everywhere.add_symbol(symbol_name, info[1], 850)
			elif symbol_name == "shield":
				Everywhere.add_symbol(symbol_name, info[1], 5)
			else:
				Everywhere.add_symbol(symbol_name, info[1])
		monitoring = false
		$Sprite2D.visible = false
		if info[1] == "none":
			$Timer.start()
