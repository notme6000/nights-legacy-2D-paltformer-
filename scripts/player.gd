extends CharacterBody2D

@export var speed = 300 #this variables are declared with export to change the values in the inspector section of the godot editor
@export var gravity = 30
@export var jump_force = 700

@onready var animation_player = $AnimationPlayer #connecting or calling the respective nodes to the variables
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionShape2D
@onready var crouch_raycast1 = $crouchraycast_1
@onready var crouch_raycast2 = $crouchraycast_2

var is_crouching = false
var stuck_under_object = false

var standing_cshape = preload("res://resources/knight_standing_cshape.tres")
var crouching_cshape = preload("res://resources/knight_crouching_cshape.tres")

func _physics_process(_delta):
	
	if !is_on_floor(): #checking if the player is on floor or not
		velocity.y += gravity#if not on floor the gravity is incremented till 1000
		if velocity.y > 1000:
			velocity.y = 1000
			
	if Input.is_action_just_pressed("jump"): #&& is_on_floor(): #this allow the user to press space bar to make the player jump
		velocity.y = -jump_force
		
	var horizontal_direction = Input.get_axis("move_left","move_right") #control the player movement horizontaly(left,right)
	velocity.x = speed * horizontal_direction 
	move_and_slide()
	update_animantions(horizontal_direction)
	
	if horizontal_direction != 0:#if the diredtion is not zero or the player is idle the function will be called
		switch_direction(horizontal_direction) 
		
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		if above_head_is_empty():
			stand()
		else:
			if above_head_is_empty():
				stand()
			else:
				if stuck_under_object != true:
					stuck_under_object = true
	
	if stuck_under_object && above_head_is_empty():
		if !Input.is_action_pressed("crouch"):
			stand()
			stuck_under_object = false
		
					
	
func above_head_is_empty() -> bool:
	var result = !crouch_raycast1.is_colliding() && !crouch_raycast2.is_colliding()
	return result
	
		
		

func update_animantions(horizontal_direction): #this function updated animation according to the action of the player
	if is_on_floor():
		if horizontal_direction == 0: #if not movement or idle the animation will play "idle"
			if is_crouching:
				animation_player.play("crouch")
			else:
				animation_player.play("idle")
		else: #else play run animation 
			if is_crouching:
				animation_player.play("crouch_walk")
			else:
				animation_player.play("run")
	else: #checks the y axis velocity for playing jumping and runnging animation 
		if is_crouching == false:
			if velocity.y < 0: #if y is less than zero jump animation is played (in godot the y becomes negative when going up)
				animation_player.play("jump")
			elif velocity.y > 0: # if y is greater than zero fall animation is played
				animation_player.play("fall")
		else:
			animation_player.play("crouch")
func switch_direction(horizontal_direction): #this function flips the sprite horizontally to match the movement animation (facing the player right when running right and vice versa)
	sprite.flip_h = (horizontal_direction ==-1)
	sprite.position.x = horizontal_direction * 3.6
	
func crouch():
	if is_crouching:
		return
	is_crouching = true
	cshape.shape = crouching_cshape
	cshape.position.y = -12

func stand():
	if is_crouching == false:
		return
	is_crouching = false
	cshape.shape = standing_cshape
	cshape.position.y = -17

	print(velocity) #prints the velocity for debugging purposes
