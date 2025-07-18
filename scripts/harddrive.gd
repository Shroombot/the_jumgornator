extends AnimatedSprite2D
@export var title = "Letter"
@export_multiline var text = ""
var inside = false

func _ready() -> void:
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D,"scale",Vector2(0.85,0.85),1)
	tween.tween_property($Sprite2D,"scale",Vector2(1,1),1)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and inside:
		if Everywhere.show_letter:
			Everywhere.show_letter = false
		else:
			Everywhere.show_letter = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		inside = true
		var tween = create_tween().set_trans(Tween.TRANS_SINE)
		tween.tween_property($Sprite2D,"modulate:a",1,0.1)
		material.set_shader_parameter("width",1)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		inside = false
		var tween = create_tween().set_trans(Tween.TRANS_SINE)
		tween.tween_property($Sprite2D,"modulate:a",0,0.1)
		material.set_shader_parameter("width",0)
