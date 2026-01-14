##// File: main.tscn
##[gd_scene load_steps=6 format=3]
##
##[ext_resource type="Script" path="res://scripts/Main.gd" id=1]
##[ext_resource type="Texture" path="res://assets/background1.png" id=2]
##[ext_resource type="Texture" path="res://assets/asteroid.png" id=3]
##[ext_resource type="Texture" path="res://assets/crosshair.png" id=4]
##
##[node name="Main" type="Node2D"]
##script = ExtResource( 1 )
##
##[node name="Background" type="Sprite2D" parent="."]
##texture = ExtResource( 2 )
##centered = true
##
##[node name="Asteroid" type="Sprite2D" parent="."]
##texture = ExtResource( 3 )
##scale = Vector2(0.5, 0.5)
##
##[node name="Crosshair" type="Sprite2D" parent="."]
##texture = ExtResource( 4 )
##
##[node name="UI" type="CanvasLayer" parent="."]
##
##[node name="TutorialLabel" type="Label" parent="UI"]
##text = "Move with WASD or Arrow Keys. Press ENTER to lock target."
##
##[node name="ResultLabel" type="Label" parent="UI"]
##visible = false
##
##
##// File: scripts/Main.gd
##extends Node2D
#
#@export var backgrounds: Array[Texture2D]
#@export var moveSpeed := 300
#
#var progress := 0
#var maxProgress := 3
#var gameActive := false
#
#@onready var bg := $Background
#@onready var asteroid := $Asteroid
#@onready var crosshair := $Crosshair
#@onready var tutorial := $UI/TutorialLabel
#@onready var result := $UI/ResultLabel
#
#func _ready():
	#bg.texture = backgrounds[0]
	#tutorial.visible = true
	#result.visible = false
	#gameActive = true
#
#func _process(delta):
	#if not gameActive:
		#return
#
	#var dir := Vector2.ZERO
	#if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		#dir.x += 1
	#if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		#dir.x -= 1
	#if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		#dir.y += 1
	#if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		#dir.y -= 1
#
	#crosshair.position += dir.normalized() * moveSpeed * delta
#
	#if Input.is_action_just_pressed("ui_accept"):
		#check_lock()
#
#func check_lock():
	#if crosshair.get_rect().intersects(asteroid.get_rect()):
		#progress += 1
		#if progress >= maxProgress:
			#win()
		#else:
			#advance_stage()
	#else:
		#lose()
#
#func advance_stage():
	#asteroid.scale *= 1.5
	#bg.texture = backgrounds[min(progress, backgrounds.size() - 1)]
#
#func win():
	#gameActive = false
	#result.text = "SUCCESS"
	#result.visible = true
#
#func lose():
	#gameActive = false
	#result.text = "FAILED"
	#result.visible = true
#
#
##File: input_map.txt
## Add these actions in Project Settings > Input Map
##move_up = W
##move_down = S
##move_left = A
##move_right = D
##
##// File: scenes/Tutorial.tscn
##[gd_scene format=3]
##
##[node name="Tutorial" type="Control"]
##
##[node name="Label" type="Label" parent="."]
##text = "Cover the asteroid with the crosshair and press ENTER."
##
##
##// File: scenes/Success.tscn
##[gd_scene format=3]
##
##[node name="Success" type="Control"]
##
##[node name="Label" type="Label" parent="."]
##text = "Mission Successful"
##
##
##// File: scenes/Failure.tscn
##[gd_scene format=3]
##
##[node name="Failure" type="Control"]
##
##[node name="Label" type="Label" parent="."]
##text = "Mission Failed"
