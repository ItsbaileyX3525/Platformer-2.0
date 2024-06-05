extends Node2D

const PlayerNode = preload("res://scenes/player.tscn")
const TutorialScene = preload("res://scenes/tutorial.tscn")
const Level1Scene = preload("res://scenes/level_1.tscn")
const Level2Scene = preload("res://scenes/level_2.tscn")

@onready var levelTimer = $NextLevel
@onready var levelCompleteSFX = $LevelComplete
@onready var PlayerLayer = $Player
@onready var background = $Background

@export var levelToLoad: int = 0

var Player: Node2D
var Tutorial: Node2D
var Level1: Node2D
var Level2: Node2D
var goingTo = 1

var finishedLoading = false
var FinishedTutorial = false
var FinishedLevel1 = false
var loadedLevel1 = false
var loadedLevel2 = false

func _on_next_level_timeout() -> void:
	levelTimer.stop()
	match goingTo:
		1:
			if is_instance_valid(Tutorial):
				Tutorial.queue_free() 
				print("Freed")
			else:
				print("Tried freeing Tutorial")
			Level1 = Level1Scene.instantiate()
			add_child(Level1)
			Player.hide_transition()
		2:
			if is_instance_valid(Level1):
				Level1.queue_free() 
				print("Freed")
			else:
				print("Tried freeing Tutorial")
			Level2 = Level2Scene.instantiate()
			add_child(Level2)
			Player.hide_transition()
func loadLevel(whichLevel: int) -> void:
	match whichLevel:
		1:
			Player.show_transition()
			levelCompleteSFX.play()
			goingTo = 1
			levelTimer.start()
		2:
			Player.show_transition()
			levelCompleteSFX.play()
			goingTo = 2
			levelTimer.start()

func _ready() -> void:
	Player = PlayerNode.instantiate()
	PlayerLayer.add_child(Player)
	Player.position = Vector2(26, 516)
	match levelToLoad:
		0:
			Tutorial = TutorialScene.instantiate()
			Tutorial.init(Player)
			add_child(Tutorial)
			Tutorial.position = Vector2(0,0)
		1:
			Level1 = Level1Scene.instantiate()
			add_child(Level1)
		2:
			Level2 = Level2Scene.instantiate()
			add_child(Level2)
	finishedLoading = true
	
	#DiscordRPC.app_id = 1247248712359739444 # Application ID
	#DiscordRPC.details = "Jumping from platform to platform"
	#DiscordRPC.large_image = "https://cdn.discordapp.com/app-assets/1247248712359739444/1247251657406943333.png"
	#DiscordRPC.large_image_text = "Chonky - Platformer"
	#DiscordRPC.small_image = "https://cdn.discordapp.com/app-assets/1247248712359739444/1247261773778911252.png"
#
	#DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
#
#
	#DiscordRPC.refresh()
func _process(delta: float) -> void:
	#DiscordRPC.run_callbacks()
	if Player:
		background.position.x = Player.position.x
		background.position.y = Player.position.y - 310
	if finishedLoading:
		if is_instance_valid(Tutorial):
			if !FinishedTutorial and Tutorial.NextLevel  and not loadedLevel1:
				loadLevel(1)
				loadedLevel1 = true
		if is_instance_valid(Level1):
			if !FinishedLevel1 and Level1.NextLevel and not loadedLevel2:
				loadLevel(2)
				loadedLevel2 = true
