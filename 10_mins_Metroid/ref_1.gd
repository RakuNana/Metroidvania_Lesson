extends CharacterBody2D


var movement = Vector2()
var speed = 100 
var jump_ht = 600
var fall_vel = 5
var current_direction = "Idle"
var morphball = false


@onready var  anim = $Samus_anim

@onready var stand_col = $Standing_col
@onready var jump_col = $Jump_col
@onready var has_a_landing1 = $Check_landing
@onready var has_a_landing2 = $Check_landing2
@onready var morphball_col = $Morphball_col



func _ready():
	
	pass
	
	
func _physics_process(delta):
	
	current_gravity()
	Player_movement()
	animation_player()
	check_morphball_state()
	
	if has_a_landing1.is_colliding() or has_a_landing2.is_colliding():
		
		stand_col.disabled = false
		jump_col.disabled = true
	
	movement = movement.normalized() * speed * delta
	move_and_slide()
	
func Player_movement():
	
	var LEFT =Input.is_action_pressed("ui_left")
	var RIGHT =Input.is_action_pressed("ui_right")
	var JUMP =Input.is_action_just_pressed("ui_accept")
	
	var DOWN = Input.is_action_just_pressed("down")
	var UP = Input.is_action_just_pressed("ui_up")
	
	movement.x = -int(LEFT) + int(RIGHT)
	movement.y = -int(JUMP)

	if movement.x != 0:
		
		velocity.x = movement.x * speed
		
	else:
		
		velocity.x = 0
		
		
	if JUMP and is_on_floor():
		
		fall_vel -= jump_ht
		
	if DOWN:
		
		morphball = true
		
	if UP:
		
		anim.flip_h = false
		morphball = false
		
		
func check_morphball_state():
	
	if morphball:
		
		stand_col.disabled = true
		jump_col.disabled = true
		morphball_col.disabled = false
		has_a_landing1.enabled = false
		has_a_landing2.enabled = false
		
	else:
		
		has_a_landing1.enabled = true
		has_a_landing2.enabled = true

func animation_player():
	
	if movement.x == -1:
		
		stand_col.position = Vector2(4,1)
		current_direction = "Left"
		
	if movement.x == 1:
		
		stand_col.position = Vector2(-1,1)
		current_direction = "Right"
			
			
	if movement.x == -1 and !is_on_floor():
		
		jump_col.disabled = false
		stand_col.disabled = true
		anim.play("SummerSault_Left")
		
	if movement.x == 1 and !is_on_floor():
		
		jump_col.disabled = false
		stand_col.disabled = true
		anim.play("SummerSault_Right")
			
			
	check_direction()
			
func check_direction():
			
	if morphball == false:
		
		if current_direction == "Left" and is_on_floor() and !morphball:
			
			anim.play_backwards("Run_L")
			
		if current_direction == "Right" and is_on_floor() and !morphball:
			
			anim.play("Run_R")
			
		if movement == Vector2.ZERO:
			
			if current_direction == "Left":
				
				anim.play("Idle_Left")
				
			if current_direction == "Right":
				
				anim.play("Idle_Right")
			
	else:
		
		if morphball and movement.x == -1:
			
			anim.flip_h = false
			anim.play("Morph_ball_L")
			
		if morphball and movement.x == 1:
			
			anim.flip_h = true
			anim.play("Morph_ball_L")
			
		if morphball and movement == Vector2.ZERO:
			
			anim.play("Morph_ball_L")
			anim.stop()
	
	
	
func current_gravity():
	
	var new_gravity = gravity_force.new()
	
	velocity.y = fall_vel
	
	if !is_on_floor():
		
		fall_vel += new_gravity.gravity_str
		
	if is_on_floor() and fall_vel > 5:
		
		fall_vel = 5
		
	if fall_vel >= new_gravity.terminal_vel:
		
		fall_vel = new_gravity.terminal_vel
		
	print(fall_vel)
	
func fire_weapon():
	
	pass
