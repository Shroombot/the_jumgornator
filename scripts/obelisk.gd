extends RigidBody2D
@export var done = false
var risen = false

func _ready() -> void:
	$Sprite2D.frame = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not risen:
		risen = true
		body.eating = true
		$AnimationPlayer.play("rise")
		$rise.play()

func _process(delta: float) -> void:
	if done:
		#if next_scene:
		Everywhere.change_level(Everywhere.level + 1)
		$AnimationPlayer.play("idle")
		done = false
