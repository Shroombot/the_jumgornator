extends Node

var unlock_text = []
var unlocked = {}
var show_letter = false
var letter_contents = ["",""]
var switch_scene = false
var scene : String
var consumable_value = 0
var ball = false
var level = 1
var symbols = {
	"jump" : ["res://assets/symbols/jump.png","space bar","none"],
	"draft" : ["res://assets/symbols/up_boost.png","none","res://sounds/woosh.mp3"],
	"bolt" : ["res://assets/symbols/bolt.png","Q","res://sounds/bolt.mp3"],
	"shield" : ["res://assets/symbols/shield.png","none","res://sounds/shield.mp3"],
	"flip" : ["res://assets/symbols/flip.png","S or Down Arrow","res://sounds/flip.mp3"],
	"reverse gravity" : ["res://assets/symbols/reverse_gravity.png","none","res://sounds/flip.mp3"],
	"ball" : ["res://assets/symbols/ball.png","F","res://sounds/flip.mp3"],
	"feather" : ["res://assets/symbols/feather.png","W or Up Arrow","res://sounds/flip.mp3"]
}
var levels = {
	1: "res://scenes/levels/level1.tscn",
	2: "res://scenes/levels/level2.tscn",
	3: "res://scenes/levels/level3.tscn",
	4: "res://scenes/levels/level4.tscn",
	5: "res://scenes/levels/level5.tscn",
	6: "res://scenes/levels/level6.tscn",
	7: "res://scenes/levels/level7.tscn",
	8: "res://scenes/levels/level8.tscn",
	9: "res://scenes/levels/level9.tscn",
	10: "res://scenes/levels/level10.tscn",
	11: "res://scenes/levels/level11.tscn",
	12: "res://scenes/levels/level12.tscn",
}

#func _process(delta: float) -> void:
	#print(unlocked)

func add_symbol(nam, key, value = 0):
	consumable_value = value
	if unlocked.has(nam):
		unlocked[nam] += 1
	else:
		unlocked[nam] = 1
	unlock_text = [nam, key]

func get_unlock(which):
	if unlocked.has(which):
		return unlocked[which] 
	else:
		return 0

func reset():
	unlocked.clear()

func change_level(which):
	if levels.has(which):
		scene = levels[which]
		level = which
		switch_scene = true
	else:
		scene = levels[1]
		level = 1
		switch_scene = true
