extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jumpForce = 600

@onready var idleChonk = $IdleChonky
@onready var idleAnim = $IdleChonky/AnimationPlayer
@onready var leftChonk = $ChonkyLeft
@onready var leftChonkAnim = $ChonkyLeft/AnimationPlayer
@onready var rightChonkAnim = $ChonkyRight/AnimationPlayer
@onready var rightChonk = $ChonkyRight
@onready var deathCounter = $RichTextLabel

var deaths = 0
var fixedTimestep = 1/60
var timer = 0.0

func  step() -> void:
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 750:
			velocity.y = 750
			
	if position.y > 1250:
		position.y = -350
		deaths+=1
		deathCounter.text = "Deaths: %s" % deaths
		position.x = 0

func _physics_process(delta):
	timer += delta
	if timer>= fixedTimestep:
		timer=0
		step()
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = -jumpForce

	if Input.is_action_just_pressed("move_left"):
		rightChonk.visible=false
		leftChonk.visible=true
	if Input.is_action_just_pressed("move_right"):
		rightChonk.visible=true
		leftChonk.visible=false
		
	var hDirection = Input.get_axis("move_left", "move_right") 
	
	velocity.x = speed * hDirection
	
	move_and_slide()

	if Input.is_key_pressed(KEY_A):
		if !leftChonkAnim.is_playing():
			idleAnim.stop()
			leftChonk.visible = true
			leftChonkAnim.play("move_left")
			rightChonkAnim.stop()
			rightChonk.visible = false
			idleChonk.visible = false
	elif Input.is_key_pressed(KEY_D):
		if !rightChonkAnim.is_playing():
			idleAnim.stop()
			leftChonk.visible = false
			leftChonkAnim.stop()
			rightChonkAnim.play("move_right")
			rightChonk.visible = true
			idleChonk.visible = false
	else:
		if !idleAnim.is_playing():
			idleAnim.play("idle")
			leftChonkAnim.stop()
			rightChonkAnim.stop()
			idleChonk.visible = true
			rightChonk.visible=false
			leftChonk.visible=false

	
