extends CharacterBody2D
class_name Player

var SPEED = 150.0
var accel = 0.5
var hit_wall = false
var flip = false
var falling = true
@export var eating = false
@export var dead = false
var jumping = false
var shielded = false
var prev_dir = 1
var dying = false
var extra_move = false
var double_jump = false
var JUMP_VELOCITY = -250.0

func _ready() -> void:
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($shield_sprite,"scale",Vector2(1.1,1.1),0.75)
	tween.tween_property($shield_sprite,"scale",Vector2(1,1),0.75)
	Everywhere.reset()

func grav(velocity: Vector2):
	var mod = 1
	if flip:
		mod = -1
	if velocity.y < 0:
		return get_gravity().y * mod
	else:
		#if is_on_wall():
			#return 100
		return 1200 * mod 

func direct_effects():
	if Everywhere.unlocked.has("draft"):
		if not dying:
			velocity.y -= 850
		Everywhere.unlocked.erase("draft")
	if Everywhere.unlocked.has("shield"):
		if not dying:
			$shield_sprite.visible = true
			$shield.start()
		Everywhere.unlocked.erase("shield")
	if Everywhere.unlocked.has("reverse gravity"):
		if not dying:
			var tween = create_tween().set_trans(Tween.TRANS_SINE)
			if flip:
				tween.tween_property(self,"rotation_degrees",0,0.1)
				flip = false
			else:
				tween.tween_property(self,"rotation_degrees",180,0.1)
				flip = true
		Everywhere.unlocked.erase("reverse gravity")
		

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("flip") and Everywhere.unlocked.has("flip") and not dying:
		var tween = create_tween().set_trans(Tween.TRANS_SINE)
		if flip:
			tween.tween_property(self,"rotation_degrees",0,0.1)
			flip = false
		else:
			tween.tween_property(self,"rotation_degrees",180,0.1)
			flip = true
	shielded = $shield.time_left > 0
	if not hit_wall and is_on_wall():
		$fall.pitch_scale = randf_range(0.95,1.05)
		$fall.play()
		hit_wall = true
	if is_on_floor() and abs(velocity.x) > 0:
		var tween = create_tween()
		tween.tween_property($runnning,"volume_db",8,0.05)
	else:
		var tween = create_tween()
		tween.tween_property($runnning,"volume_db",-80,0.05)
		
	if not is_on_wall():
		hit_wall = false
	direct_effects()
	if dead:
		Everywhere.scene = get_tree().current_scene.scene_file_path
		Everywhere.switch_scene = true
	#Animation
	if Input.is_action_just_pressed("bolt") and Everywhere.unlocked.has("bolt") and not dying:
		$dash.pitch_scale = randf_range(0.95,1.05)
		$dash.play()
		velocity.x += prev_dir * SPEED * 2
		extra_move = true
		$extra_move.start()
	if not dead:
		if dying:
			if $shield.time_left > 0:
				dying = false
			else:
				$AnimationPlayer.play("die")
				
		elif eating:
			$AnimationPlayer.play("eat")
		elif abs(velocity.x) > 0:
			$AnimationPlayer.play("walk")
		else:
			$AnimationPlayer.play("idle")

	if is_on_floor() and falling:
		
		#$land.emitting = true
		$fall.pitch_scale = randf_range(0.95,1.05)
		$fall.play()
		#$"../CanvasLayer/ColorRect".shake(0.05)
		falling = false
		#var tween = create_tween().set_trans(Tween.TRANS_SINE)
		#tween.tween_property($Sprite2D,"scale",Vector2(2,0.5),0.1)
		#tween.set_parallel(true)
		##tween.tween_property($Sprite2D,"position:y",10,0.1)
		#tween.set_parallel(false)
		#tween.tween_property($Sprite2D,"scale",Vector2(1,1),0.1)
		#tween.set_parallel(true)
		#tween.tween_property($Sprite2D,"position:y",0,0.1)
		
	var tween = create_tween().set_parallel()
	#if abs(velocity.x) > 0 and is_on_floor():
		#var tweener = create_tween()
		#tweener.tween_property($running,"volume_db",0,0.5)
	#else:
		#var tweener = create_tween()
		#tweener.tween_property($running,"volume_db",-80,0.5)
	if velocity.x > 0:
		#$CPUParticles2D.emitting = true
		#tween.tween_property($Sprite2D,"rotation_degrees",-10,0.1)
		tween.tween_property($Camera2D,"offset:x",30,0.5)
	elif velocity.x < 0:
		#$CPUParticles2D.emitting = true
		#tween.tween_property($Sprite2D,"rotation_degrees",10,0.1)
		tween.tween_property($Camera2D,"offset:x",-30,0.5)
	else:
		#$CPUParticles2D.emitting = false
		#tween.tween_property($Sprite2D,"rotation_degrees",0,0.1)
		tween.tween_property($Camera2D,"offset:x",0,1.5)
	
	# Add the gravity.
	if flip:
		if not is_on_ceiling():
			falling = true
			velocity.y += grav(velocity) * delta
	else:
		if not is_on_floor():
			falling = true
			velocity.y += grav(velocity) * delta
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY/4
	# Handle jump.
	var was_on_floor = is_on_floor()
	if is_on_floor():
		double_jump = false
	if Input.is_action_just_pressed("jump") and not dying:
		#if is_on_wall():
			#jump(true)
		if is_on_floor() or is_on_ceiling() or $coyote.time_left > 0:
			if (flip and is_on_ceiling()) or (not flip and is_on_floor()) or $coyote.time_left > 0:
				if Everywhere.get_unlock("jump") > 0:
					jump()
		else:
			if not double_jump and Everywhere.get_unlock("jump") > 1:
				double_jump = true
				jump(true)
			$jump_buffer.start(0.2)
	#if is_on_ceiling():
		#velocity.y = 0
	$shield_sprite/Label.text = str(int($shield.time_left))
	if prev_dir == 1:
		if flip:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	else:
		if flip:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
			
	if is_on_floor() and $jump_buffer.time_left > 0:
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction and not dying:
		if accel < 1:
			accel += 0.1
		if not extra_move:
			velocity.x = direction * SPEED * accel
		prev_dir = direction
	else:
		accel = 0.5
		velocity.x = move_toward(velocity.x, 0, 21)
	#if get_slide_collision_count() > 0:
		#for i in get_slide_collision_count():
			#var col = get_slide_collision(i)
			#if col.get_collider() is RigidBody2D:
				#col.get_collider().apply_force(col.get_normal() * - 1000)
	if was_on_floor and not is_on_floor():
		$coyote.start()
	move_and_slide()

func jump(double = false):
	if not jumping:
		jumping = true
		if double:
			$jump.pitch_scale = randf_range(1.1,1.15)
		else:
			$jump.pitch_scale = randf_range(0.95,1.05)
		$jump.play()
		#if velocity.x < 0:
			#var tweener = create_tween()
			#tweener.tween_property($Sprite2D,"rotation_degrees",$Sprite2D.rotation_degrees - 90,0.1)
		#else:
			#var tweener = ceate_tween()
			#tweener.tween_property($Sprite2D,"rotation_degrees",$Sprite2D.rotation_degrees + 90,0.1)
		var tween = create_tween().set_trans(Tween.TRANS_SINE)
		tween.tween_property($Sprite2D,"scale",Vector2(0.5,2),0.2)
		tween.tween_property($Sprite2D,"scale",Vector2(1,1),0.1)
		if flip:
			velocity.y = JUMP_VELOCITY * -1
		else:
			velocity.y = JUMP_VELOCITY
		await get_tree().create_timer(0.25).timeout
		jumping = false
	

func _on_extra_move_timeout() -> void:
	extra_move = false

func _on_shield_timeout() -> void:
	$shield_sprite.visible = false
