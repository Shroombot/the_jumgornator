extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not body.shielded:
		$spike.play()
		body.dying = true
